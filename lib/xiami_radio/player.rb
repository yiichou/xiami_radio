require 'audite'

module XiamiRadio
  # There is a player as you saw
  class Player

    attr_reader :track, :next_track, :radio, :user

    def initialize(radio:, _playlist: nil)
      @radio, @user = radio, radio.client.user
      @player = Audite.new
      @view = View::Player.new self

      @player.events.on :position_change, &method(:position_change)
      @player.events.on :complete, &method(:complete)
      @view.listen_on
    end

    def play
      @track = @radio.next_track
      @player.queue @track.file_path
      @player.set_current_song
      @player.start_stream
      @player.thread.join
    end

    def next
      if @next_track.nil?
        @next_track = @radio.next_track
        @player.queue @next_track.file_path
      end
      @track, @next_track = @next_track, nil
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
      @view.refresh position

      if @next_track.nil? && position / @track.duration > 0.7
        Thread.start do
          @track.record
          @next_track = @radio.next_track
          @player.queue @next_track.file_path
        end
      end
    end

    def complete
      @track, @next_track = @next_track, nil
    end

    def self.play(radio)
      player = new radio: radio
      player.play
      player
    end
  end
end
