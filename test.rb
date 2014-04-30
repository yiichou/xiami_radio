require_relative './a'
require_relative 'helpers/download_thread'

player = Audite.new

player.events.on(:position_change) do |pos|
  puts "POSITION: #{pos} seconds  level #{player.level}"
end

player.events.on(:complete) do
  puts "COMPLETE"
end

location = 'http://m5.file.xiami.com/712/55712/435293/1771115301_3944660_l.mp3?auth_key=4eb62d1cd78e281a243efeee2283cd08-1407513600-0-null'
file = './cache/test.mp3'

@download = DownloadThread.new(location, file)

# player.load(file)
# player.start_stream
# player.thread.join