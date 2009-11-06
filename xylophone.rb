require 'rubygems'
require 'sinatra'
require 'erb'
require 'sequel'

#
# Setup
#


#
# For arduino
#

# Get list of songs in queue.
get '/queue' do
end

# Get next song from queue.
get '/next' do
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
  params['row'].inspect
end

# Show song page.
get '/song/:id' do
end

get '/about' do
  "I'm running on Sinatra " + Sinatra::VERSION
end

not_found do
  'No presents for bad children.'
end

