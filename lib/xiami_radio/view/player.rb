require 'curses'

module XiamiRadio
  module View
    class Player
      include Curses
      
      def initialize
        init_screen
        noecho
        stdscr.keypad true
        curs_set 0
        start_color
        init_pair(COLOR_CYAN, COLOR_CYAN, COLOR_BLACK)
        init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK)
      end

      alias_method :curses_refresh, :refresh
      def refresh(track, position)
        render_title_line track
        render_progress_line (position / track.duration), track.downloader.progress
        render_info_line track, position
        render_msg_line
        Curses.refresh
      end

      def listen_on(player)
        Thread.start do
          while (key = getch)
            case key
              when KEY_LEFT
                player.rewind
              when KEY_RIGHT
                player.forward
              when KEY_DOWN
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
        setpos(0, 0)
        clrtoeol
        addstr('Now is playing ')
        attron(color_pair(COLOR_RED)|A_NORMAL) {
          addstr("  #{track.title} - #{track.artist}  ")
        }
        if User.instance.login?
          track.grade? ? addstr('    已收藏 ') : addstr('    按"L"加入收藏 ')
        end
      end

      def render_progress_line(play_rate, dawnload_rate)
        d_cols = [(dawnload_rate * cols).round, cols].min
        p_cols = [(play_rate * cols).round, d_cols].min
        setpos(1, 0)
        clrtoeol
        addstr('_' * p_cols + '#' * (d_cols - p_cols) + ' ' * (cols - d_cols))
      end

      def render_info_line(track, position)
        setpos(2, 0)
        clrtoeol
        addstr("#{track.reason.content}")
        addstr(": #{track.reason.title} ") unless track.reason.title.nil?
        addstr("- #{track.reason.artist} ") unless track.reason.artist.nil?
        addstr("    播放进度: ")
        attron(color_pair(COLOR_CYAN)|A_NORMAL) {
          addstr(" #{sec_2_min position} / #{sec_2_min track.duration} ")
        }
      end

      def render_msg_line(msg = XiamiRadio::Notice.shift)
        setpos(3, 0)
        clrtoeol
        addstr(msg || '')
      end

      def sec_2_min(sec)
        Time.at(sec).utc.strftime('%M:%S')
      end
    end
  end
end
