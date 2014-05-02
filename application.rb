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
    @list = @radio.get
    exit if ! @list
    
    @list
  end
  
  def track(hash)
    @track = Track.new(hash)
    
    # hd_url = @radio.get_hd(@track.song_id)
    # @track.location(hd_url)
  end
  
  def create_player
    @player = Audite.new
    @view = View.new
    @player.events.on(:position_change) do |position|
      @view.playing(@track, position, @download.total, File.size?(@file))
    end

    @player.events.on(:complete) do
      puts "COMPLETE"
      self.next
    end
    
    @view.refresh
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
      when ' '
        @player.toggle
      end
    end
    
    @player.thread.join
  end
  
  def next
    @queue += 1
    play
  end
  
  def self.logger
    @logger ||= Logger.new('debug.log')
  end

end