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

NOTES = 'CDEFGABcdefga'

configure :development do
  DB = Sequel.sqlite('xylophone.db')
  set :smtp_server, 'mail.neti.ee'
end

configure :production do
  DB = Sequel.sqlite('../../shared/xylophone.db')  
  set :smtp_server, 'bouncer.taevas.com'
end

configure do
  LOGGER = Logger.new("sinatra.log") 
end

load 'models.rb'

#
# For arduino
#

# Get list of songs in queue.
get '/queue' do
  @songs = Song.filter(:status => ['NEW']).order(:id)
  erb :queue
end

# Get next song from queue. Also check if any new songs
# are uploaded to webserver and send notification email.
get '/next' do
  
  # Use request as poor mans cron for sending notification
  # of new video files recently rsynced to webserver.
  recording = Song.filter(:status => ['RECORDING'])
  recording.each do |@song|
    # If we have video file send the email.
    if File.exists?(@song.file_path)
      begin
        Pony.mail :to => @song.email, 
                  :from => 'webmaster@taevas.ee',
                  :subject => 'Your song is ready',
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
  erb :index
end

# New song editor.
get '/song/?' do
  @title = 'More jingle bells soon at theatre near you!'
  @notes = NOTES.split(//)
  @width = NOTES.length * 16
  erb :editor
end

# Save new song to database.
post '/song' do
  @song = Song.create(:data => notes_to_char_string_csv, 
                      :status => 'NEW', 
                      :email => params[:email])
  redirect '/song/' + @song.id.to_s
end

# Show song page if song with given id exists.
get '/song/:id' do
  @song = Song[params[:id]]
  if @song
    erb :song
  else
    not_found
  end
end

# Show player if video file exists else return 404.
# This gets called with jQuery.load()
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
  @greeting = Greeting[params[:id]]
  if @greeting
    erb :greeting
  else
    not_found
  end
end

# Save new greeting to dabase.
post '/greeting' do
  @greeting = Greeting.create(:song_id => params[:song_id], 
                              :from => params[:from],
                              :user => params[:user],
                              :to => params[:to],
                              :friend => params[:friend],
                              :message => params[:message])

  Pony.mail :to => @greeting.to, 
            :from => @greeting.from, 
            :subject => 'Xylophone from Inttertubes',
            :body => erb(:email, :layout => false),
            :via => :smtp, 
            :smtp => {
                :host   => options.smtp_server
            }

    redirect '/greeting/' + @greeting.id.to_s
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
  
  def notes_to_char_string_csv
    notes_to_char_string_array.join(',')
  end
  
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
