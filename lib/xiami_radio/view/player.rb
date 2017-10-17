require 'curses'

module XiamiRadio::View
  class Player
    attr_reader :player

    def initialize(player)
      @player = player
      Curses.init_screen
      Curses.noecho
      Curses.stdscr.keypad(true)
      Curses.start_color
      Curses.use_default_colors
      Curses.init_pair(Curses::COLOR_CYAN,Curses::COLOR_CYAN,Curses::COLOR_BLACK)
      Curses.init_pair(Curses::COLOR_RED,Curses::COLOR_RED,Curses::COLOR_BLACK)
      Curses.clear
    end

    def refresh(position)
      Curses.clear
      render_title_line player.track
      render_progress_line (position / player.track.duration), player.track.downloader.progress
      render_info_line player.track, position
      render_msg_line
      Curses.refresh
    end

    def listen_on
      Thread.start do
        while (key = Curses.getch)
          case key
            when Curses::KEY_LEFT
              player.rewind
            when Curses::KEY_RIGHT
              player.forward
            when Curses::KEY_DOWN
              player.next
            when 'l'
              XiamiRadio::Notice.push player.track.fav
            when ' '
              player.toggle
            else #
          end
        end
      end
    end

    private

    def render_title_line(track)
      Curses.setpos(0, 0)
      Curses.addstr('Now is playing ')
      Curses.attron(Curses.color_pair(Curses::COLOR_RED)|Curses::A_NORMAL){
        Curses.addstr("  #{track.title} - #{track.artist}  ")
      }
      if @player.user.login?
        track.grade? ? Curses.addstr('    已收藏 ') : Curses.addstr('    按"L"加入收藏 ')
      end
    end

    def render_progress_line(play_rate, dawnload_rate)
      p = (play_rate * Curses.cols).round
      d = (dawnload_rate * Curses.cols).round - p
      Curses.setpos(1, 0)
      Curses.addstr('_' * p + '#' * d + ' ' * (Curses.cols - p - d))
    end

    def render_info_line(track, position)
      Curses.setpos(2, 0)
      Curses.addstr("#{track.reason.content}")
      Curses.addstr(": #{track.reason.title} ") unless track.reason.title.nil?
      Curses.addstr("- #{track.reason.artist} ") unless track.reason.artist.nil?
      Curses.addstr("    播放进度: ")
      Curses.attron(Curses.color_pair(Curses::COLOR_CYAN)|Curses::A_NORMAL){
        Curses.addstr(" #{sec_2_min position} / #{sec_2_min track.duration} ")
      }
    end

    def render_msg_line(msg = XiamiRadio::Notice.shift)
      return if msg.nil?
      Curses.setpos(3, 0)
      Curses.addstr(msg)
    end

    def sec_2_min(sec)
      Time.at(sec).utc.strftime('%M:%S')
    end

  end
end
