require 'curses'

class View
  def initialize
  end
  
  def playing(track, position, process)
    p = (position / track.duration * Curses.cols).ceil
    d = (process / track.size.to_f * Curses.cols).ceil - p
    Curses.clear
    Curses.setpos(0, 0)
    Curses.addstr("playing #{track.name}    #{position.ceil} seconds of #{track.duration.ceil} total")
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