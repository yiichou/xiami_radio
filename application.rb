require 'logger'
require 'curses'

require_relative 'controllers/player_controller'

require_relative 'models/collection'
require_relative 'models/player'
require_relative 'models/track'

require_relative 'views/player_view'

require_relative 'helpers/events'
require_relative 'helpers/input'
require_relative 'helpers/time_helper'

module XiamiFm
  class Application
    include Controllers
    include Models
    include Views

    def initialize()
      $stderr.reopen("debug.log", "w")
      
      @player_controller = PlayerController.new(PlayerView.new(Curses.cols, 5, 0, 0))
    
      @player_controller.events.on(:complete) do
        puts "end"
        # @track_controller.next_track
      end

    end
    
    def main
      track = Track::new({'id'=>'paomo2'})
      
      @player_controller.play(track)
    end
    
    def run
      main
    end
    
    # TODO: look at active controller and send key to active controller instead
    def handle(key)
      case key
      when :left, :right, :space
        @player_controller.events.trigger(:key, key)
      end
    end
    
    def stop
      @stop = true
    end
    
    def stop?
      @stop == true
    end
    
    def self.logger
      @logger ||= Logger.new('debug.log')
    end

  end
end