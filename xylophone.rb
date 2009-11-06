require 'rubygems'
require 'sinatra'
require 'erb'
require 'sequel'

#
# Setup
#

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
  erb :song
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
  erb :editor
end

# Save new song to dabase.
post '/song' do
  @song = Song.create(:data => notes_to_binary_string_csv, :status => 'NEW')
  erb :song
end

# Show song page.
get '/song/:id' do
  @song = Song[params[:id]]
  erb :song
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
  
  def notes_to_binary_string_array
    rows = []
    
    params['notes'].each do |row, row_notes| 
      binary = '000000000000000'
      row_notes.each do |key, value|
        binary[key.to_i] = value
      end 
      rows[row.to_i] = '0b0' << binary
    end
    # Convert any nil to binary zero
    rows.map! do |binary|
      binary ||= '0b0000000000000000'
    end
    rows
  end
  
  def notes_to_binary_string_csv
    notes_to_binary_string_array.join(',')
  end
  
end


