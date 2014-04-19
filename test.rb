require 'audite'

player = Audite.new

player.load('./cache/sac.mp3')
player.start_stream

sleep 10