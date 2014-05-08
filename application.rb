require 'logger'
require 'net/http'
require 'curses'

require_relative 'audite'
require_relative 'download_thread'
require_relative 'view'
require_relative 'radio'
require_relative 'track'

class XiamiFm

  def initialize
    @folder = File.expand_path("./cache")
    @radio = Radio.new
    @queue = 0
    create_player
    
    Dir.mkdir(@folder) unless File.exist?(@folder)
  end
  
  def list
    @list ||= @radio.get
    exit if ! @list
    
    @list
  end
  
  def track(hash)
    @track = Track.new(hash)
    
    hd_url = @radio.get_hd(@track.song_id)
    @track.location(hd_url)
  end
  
  def create_player
    @player = Audite.new
    @view = View.new
    @player.events.on(:position_change) do |position|
      down_rate = @download.progress / @download.total.to_f
      play_rate = position / @track.duration.to_f
      
      if down_rate - play_rate < 0.02 && down_rate < 0.98
        @player.toggle
        sleep 2
        @player.toggle
      end
      
      @view.playing(@track, position, down_rate)
    end

    @player.events.on(:complete) do
      Thread.start do
        @radio.record(@track.song_id)
      end
      self.next
    end

  end
  
  def play
    track(list[@queue])
    
    @file = "#{@folder}/tmp.mp3"
    @download = DownloadThread.new(@track.location, @file)
    
    @player.load(@file)
    @player.start_stream
    
    while c = Curses.getch
      case c
      when Curses::KEY_LEFT
        @player.rewind
      when Curses::KEY_RIGHT
        @player.forward
      when Curses::KEY_DOWN
        @player.stop_stream
        self.next
      when 'l'
        @radio.fav(@track.song_id)
      when ' '
        @player.toggle
      end
    end
    
    @player.thread.join
  end
  
  # TODO: 列表播放完时的处理
  def next
    @download.stop
    @queue += 1
    play
  end
  
  def self.logger
    @logger ||= Logger.new('debug.log')
  end

end