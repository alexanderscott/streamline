require 'hallon'
require 'hallon/openal'
require "json"
require "yaml"

require './encrypt.rb'
require './creds.rb'
require './utils'

require 'csv'


@pass = $password
if $creds_encrypted == false
  @pass = encrypt_pass($username, $password) 
end

session = Hallon::Session.initialize IO.read('./spotify_appkey.key')
session.login!($username, decrypt_pass(@pass))



streamType, streamObj = ARGV

if streamType == 'song' or streamType == 'artist'
  puts "Attempting to stream #{streamType} :: #{streamObj}"


  search = Hallon::Search.new(streamObj)
  search.load
  tracks = search.tracks[0...10].map(&:load)

  puts "Top 10 Results"
  tracks.each do |track|
    puts "#{track.artist.name} - #{track.name} - #{secondsToTime(track.duration)}"
  end


  player = Hallon::Player.new(Hallon::OpenAL)
  player.play!(tracks.first)
end

if streamType == 'import-csv'
  puts "Attempting to import from CSV into playlist"
  CSV.foreach( streamObj ) do |row|
    song_name, song_duration, artist_name, playlist_name = row
    puts row.inspect
    playlist = Hallon::Playlist.initialize(playlist_name)

    # Search for the song and matching artist
    search = Hallon::Search.new(streamObj)
    search.load
    tracks = search.tracks[0...10].map(&:load)

    tracks.each do |track|
      if track.artist.name == artist_name
        puts "Inserting into playlist:: #{playlist_name} :: track :: #{track.artist.name} - #{track.name} - #{secondsToTime(track.duration)}"
        playlist.insert(track) 
        break
      end
    end
  end
  
end
