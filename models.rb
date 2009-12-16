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

DB.create_table? :songs do
  primary_key :id
  String :data
  String :email
  String :status
end

class Song < Sequel::Model
  def file_name
    'song-' + self.id.to_s + '.mov'
  end
  
  def file_path
    File.join(File.dirname(__FILE__), 'public', 'system', 'rsync', self.file_name)  
  end
  
  def url
    'http://xylophone.taevas.ee/song/' + self.id.to_s
  end
    
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