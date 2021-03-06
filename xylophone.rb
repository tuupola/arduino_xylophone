#
# Xylophone - Sinatra app for Internet controlled xylophone
#
# Copyright (c) 2009 Mika Tuupola
#
# Licensed under the MIT license:
#   http://www.opensource.org/licenses/mit-license.php
#
# Project home:
#   https://github.com/tuupola/arduino_xylophone
#
 
require 'rubygems'
require 'sinatra'
require 'erb'
require 'sequel'
require 'pony'
require 'logger'

#
# Setup
#

enable :sessions

NOTES = 'CDEFGABcdefga'

configure :development do
  DB = Sequel.sqlite('xylophone.db')
  LOGGER = Logger.new("sinatra.log") 
  set :smtp_server, 'mail.neti.ee'
end

configure :production do
  DB = Sequel.sqlite('../../shared/xylophone.db')  
  LOGGER = Logger.new("../../logs/sinatra_log") 
  set :smtp_server, 'bouncer.taevas.com'
end

load 'models.rb'

#
# For arduino
#

# Get next song from queue. Also check if any new songs
# are uploaded to webserver and send notification email.
get '/next' do
  
  # Use this request as poor mans cron to send email
  # notifications of videos which are ready.
  send_email_notifications

  # Give next from the queue to Arduino.
  @song = Song.filter(:status => ['NEW']).order(:id).first
  if @song
    @song.status = 'RECORDING'
    @song.save
    erb :song_txt, :layout => false
  end  

end

#
# For browser
#

get '/' do
  @title = 'Jingle bells, jingle bells, jingle all the way...'
  @lang = session['lang']
  
  erb :index
end

get '/en' do
  session['lang'] = 'en'
  redirect '/'
end

get '/et' do
  session['lang'] = 'et'
  redirect '/'
end

# New song editor.
get '/song/?' do
  @lang = session['lang']
  
  @title = 'More jingle bells soon at theatre near you!'
  @notes = NOTES.split(//)
  @width = NOTES.length * 16
  erb :editor
end

# Save new song to database.
post '/song' do
  @lang = session['lang']
  
  @song = Song.create(:data => notes_to_char_string_csv, 
                      :status => 'NEW', 
                      :name  => params[:name], 
                      :email => params[:email],
                      :language => @lang)
  redirect '/song/' + @song.id.to_s
end

# Show song page if song with given id exists.
get '/song/:id' do
  @song = Song[params[:id]]
  @lang = session['lang']

  if @song
    erb :song
  else
    not_found
  end
end

# Show player if video file exists else return 404.
# This gets called with jQuery.load() from page /song/:id
get '/song/ajax/:id' do
  @song = Song[params[:id]]
  if File.exists?(@song.file_path) 
    @song = Song[params[:id]]
    erb :ajax_song, :layout => false
  else
    not_found
  end
end

# Show a greeting.
get '/greeting/:id' do
  @lang = session['lang']
  
  @greeting = Greeting[params[:id].to_i(36) - 10000]
  if @greeting
    @lang = @greeting.song.language
    erb :greeting
  else
    not_found
  end
end

# Save new greeting to database.
post '/greeting' do
  
  # Email addresses separated by space or comma
  params[:to].split(/[ ,]+/).each do |to| 
    to.strip

    @greeting = Greeting.create(:song_id => params[:song_id], 
                                :from => params[:from],
                                :user => params[:user],
                                :to => to,
                                :friend => params[:friend],
                                :message => params[:message])

    Pony.mail :to => @greeting.to, 
              :from => @greeting.from, 
              :subject => 'Sõnum Taevast!',
              :body => erb(:email, :layout => false),
              :via => :smtp, 
              :smtp => {
                  :host   => options.smtp_server
              }
    
    logger.debug "Greeting from " + @greeting.from + " to " +  @greeting.to 
  end
  

    redirect '/greeting/' + (@greeting.id + 10000).to_s(36)
end


# Show a random song
get '/random' do
  @lang = session['lang']
  
  @song = Song[rand(1 + Song.dataset.count)]
  erb :random  
end



get '/about' do
  "I'm running on Sinatra " + Sinatra::VERSION
end

not_found do
  'No presents for bad children.'
end

#
# Helper functions
#

helpers do
  
  # Send email notification to user if their video is already been
  # rsynced to webserver.
  def send_email_notifications
    recording = Song.filter(:status => ['RECORDING'])
    recording.each do |@song|
      # If we have video file send the email.
      if File.exists?(@song.file_path)
        begin
          Pony.mail :to => @song.email, 
                    :from => 'webmaster@taevas.ee',
                    :subject => 'Sinu Taevalik video',
                    :body => erb(:notification_email, :layout => false),
                    :via => :smtp, 
                    :smtp => {
                        :host   => options.smtp_server
                    } 
          @song.status = 'DONE'
          logger.debug "Sent email to " + @song.email + 
                       " with song id " + @song.id.to_s + "."

        # Probably broken email address. Log and forget.
        rescue Exception => e
          logger.debug "Sending mail to " + @song.email + " failed."
          @song.status = 'EMAIL_FAILED'
        end      
        @song.save
      end
    end
  end
  
  # Transform submitted note rows to array of strings where
  # each string represents a row. For example:
  #
  # ['C00000000000','0D00000000000','C000000000000']
   
  def notes_to_char_string_array
    rows = []
    
    params['notes'].each do |row, row_notes| 
      string_of_notes = empty_row_of_notes
      row_notes.each do |key, value|
        string_of_notes[key.to_i] = value
      end 
      rows[row.to_i] = string_of_notes
    end
    # Convert any nil to empty row of notes
    rows.map! do |string_of_notes|
      string_of_notes ||= empty_row_of_notes
    end
    rows
  end

  # Transform submitted notes to one long string. Each row
  # is separated with comma. For example:
  #
  # 'C00000000000,0D00000000000,C000000000000'
    
  def notes_to_char_string_csv
    notes_to_char_string_array.join(',')
  end
  
  # Helper method for above. Returns string of zeroes:
  #
  # '0000000000000'
  def empty_row_of_notes
    empty_row = '';
    NOTES.length.times do
      empty_row << '0';
    end
    empty_row
  end
  
  def logger
    LOGGER
  end  
  
end
