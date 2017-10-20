require 'audite'

module XiamiRadio
  # There is a player as you saw
  class Player

    attr_reader :track, :next_track, :radio

    def initialize(radio:, _playlist: nil)
      @radio = radio
      @player = Audite.new
      @view = View::Player.new

      @player.events.on :position_change, &method(:position_change)
      @player.events.on :complete, &method(:complete)
      @view.listen_on self
    end

    def play
      @track = @radio.next_track
      @player.queue @track.file_path
      @player.set_current_song
      @player.start_stream
      @player.thread.join
    end

    def next
      @track.downloader.stop
      preload! unless preload?
      unperload!
      @player.request_next_song
    end

    def rewind
      @player.rewind
    end

    def forward
      @player.forward
    end

    def toggle
      @player.toggle
    end

    private

    def position_change(position)
      @view.refresh @track, position unless position > @track.duration

      Thread.start do
        preload!
        @track.record
      end if !preload? && position / @track.duration > 0.7
    end

    def complete
      @track, @preload_track = @preload_track, nil
    end

    def preload?
      @preload_flag ||= false
    end

    def preload!
      @preload_flag = true
      @preload_track = @radio.next_track
      @player.queue @preload_track.file_path
    end

    def unperload!
      @preload_flag = false
      @track, @preload_track = @preload_track, nil
    end

    def self.play(radio)
      player = new radio: radio
      player.play
      player
    end
  end
end
