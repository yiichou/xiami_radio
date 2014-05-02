require 'curses'

class View
  def initialize
  end
  
  def playing(track, position, size, process)
    p = (position / track.duration.to_f * Curses.cols).ceil
    d = (process / size.to_f * Curses.cols).ceil - p
    Curses.clear
    Curses.setpos(0, 0)
    Curses.addstr("playing #{track.title}    #{position.ceil} seconds of #{track.duration} total")
    Curses.setpos(1, 0)
    Curses.addstr("_" * p + "#" * d + " " * (Curses.cols - p - d))
    Curses.refresh
  end
  
  def refresh
    Curses.init_screen
    Curses.noecho
    Curses.stdscr.keypad(true)
    Curses.clear
  end


end