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

#
# Setup
#

NOTES = 'CDEFGABcdefga'

DB = Sequel.sqlite('xylophone.db')

DB.create_table? :songs do
  primary_key :id
  String :data
  String :status
end

class Song < Sequel::Model
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
  @song = Song.create(:data => notes_to_char_string_csv, :status => 'NEW')
  erb :song
end

# Show song page.
get '/song/:id' do
  @song = Song[params[:id]]
  erb :song
end

# Show song page.
get '/song/ajax/:id' do
  @file_name = 'song-' + params[:id] + '.mov'
  path = File.join(File.dirname(__FILE__), 'public', 'video', @file_name)
  if File.exists?(path) 
    @song = Song[params[:id]]
    erb :ajax_song, :layout => false
  else
    not_found
  end

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


