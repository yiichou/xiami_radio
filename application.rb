require 'logger'
require 'net/http'
require 'curses'
# require 'audite'

require_relative 'audite'
require_relative 'download_thread'
require_relative 'view'
require_relative 'radio'
require_relative 'track'

class << XiamiFm

  def initialize
    @folder = File.expand_path("./cache")
    @radio = Radio.new
    @msg = nil
    create_player

    Dir.mkdir(@folder) unless File.exist?(@folder)
  end

  def list
    @list ||= []
    @list += @radio.get if @list.length < 2

    log @list.length

    @list
  end

  def track(hash)
    @track = Track.new(hash)

    if HdSwitch === "on"
      hd_url = @radio.get_hd(@track.song_id)
      @track.location(hd_url)
    end
  end

  def create_player
    @player = Audite.new
    @view = View.new
    @player.events.on(:position_change) do |position|
      down_rate = @download.progress / @download.total.to_f
      play_rate = position / @track.duration.to_f

      if down_rate - play_rate < 0.02 && down_rate < 0.98
        @player.toggle
        sleep 1
        @player.toggle
      end

      @view.playing(@track, position, down_rate, @msg)
    end

    @player.events.on(:complete) do
      Thread.start do
        @radio.record(@track.song_id)
      end
      self.next
    end

  end

  def play
    track(list.shift)

    @file = "#{@folder}/tmp.mp3"
    @download = DownloadThread.new(@track.location, @file)

    @player.load(@file)

    # Sometimes, we got the mp3 information without length from xiami
    # So, we need to calculate the length and fix it.
    @track.duration(@player.length_in_seconds(@download.total)) if @track.duration == 0

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
        msg = @radio.fav(@track.song_id)
        send_msg(msg)
      when ' '
        @player.toggle
      end
    end

    @player.thread.join
  end

  def next
    @download.stop
    send_msg(nil)

    play
  end

  def send_msg(msg)
    @msg = msg
    @msg && Thread.start do
      sleep 3
      @msg = nil
    end
  end

  def self.logger
    @logger ||= Logger.new('debug.log')
  end

  def log(s)
    XiamiFm.logger.debug("application    #{s}")
  end

end