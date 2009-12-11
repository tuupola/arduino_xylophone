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

#
# Setup
#

NOTES = 'CDEFGABcdefga'

configure :development do
  DB = Sequel.sqlite('xylophone.db')
end

configure :production do
  DB = Sequel.sqlite('/export/www/xylophone.taevas.ee/shared/xylophone.db')
end

DB.create_table? :songs do
  primary_key :id
  String :data
  String :email
  String :status
end

class Song < Sequel::Model
end

DB.create_table? :greetings do
  primary_key :id
  Integer :song_id
  String :from
  String :user
  String :to
  String :friend
  String :message
end

class Greeting < Sequel::Model
  many_to_one :song
  
  def url
    'http://xylophone.taevas.ee/greeting/' + self.id.to_s
  end
  
end

#
# For arduino
#

# Get list of songs in queue.
get '/queue' do
  @songs = Song.dataset.filter(:status => ['NEW']).order(:id)
  erb :queue
end

# Get next song from queue.
get '/next' do
  @song = Song.dataset.filter(:status => ['NEW']).order(:id).first
  if @song
    @song.status = 'DONE'
    @song.save
    erb :song_txt, :layout => false
  end
end

# Remove song from queue.
get '/done/:id' do
end

#
# For browser
#

get '/' do
  @title = 'Jingle bells, jingle bells, jingle all the way...'
  erb :index
end

# New song editor.
get '/song' do
  @title = 'More jingle bells soon at theatre near you!'
  @notes = NOTES.split(//)
  @width = NOTES.length * 16
  erb :editor
end

# Save new song to dabase.
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
get '/song/ajax/:id' do
  @file_name = 'song-' + params[:id] + '.mov'
  path = File.join(File.dirname(__FILE__), 'public', 'system', 'rsync', @file_name)
  if File.exists?(path) 
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
                :host   => 'bouncer.taevas.ee'
            }

  erb :greeting
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
  
  
end


