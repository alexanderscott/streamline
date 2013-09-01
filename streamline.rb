require 'hallon'
require 'hallon/openal'
require "json"
require "yaml"

require './encrypt.rb'
require './creds.rb'
require './utils'


@pass = $password
if $creds_encrypted == false
  @pass = encrypt_pass($username, $password) 
end

session = Hallon::Session.initialize IO.read('./spotify_appkey.key')
session.login!($username, decrypt_pass(@pass))


streamType, streamObj = ARGV

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
