require './creds.rb'
require 'hallon'
require 'hallon/openal'

session = Hallon::Session.initialize IO.read('./spotify_appkey.key')
session.login!($username, $password)


streamType, streamObj = ARGV

puts "Attempting to stream #{streamType} :: #{streamObj}"


search = Hallon::Search.new(streamObj)
search.load
tracks = search.tracks[0...5].map(&:load)

puts "Top 5 Results"
tracks.each do |track|
  puts "#{track.artist.name} - #{track.name}"
end


player = Hallon::Player.new(Hallon::OpenAL)
player.play!(tracks.first)
