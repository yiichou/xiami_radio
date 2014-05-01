class Track
  def initialize(track)
    @track = track
  end
  
  def song_id
    @track['song_id']
  end
  
  def singers
    @track['singers']
  end
  
  def name
    @track['name']
  end
  
  def location
    @track['location']
  end
  
  def title
    @track['title']
  end
  
  def artist_name
    @track['artist_name']
  end
  
  def lyric
    @track['lyric']
  end
  
  def update(total_seconds, total_size = nil, piece_seconds = nil, piece_size = nil)
    @track['size'] = total_size
    
    if total_seconds < 10
      @track['duration'] = total_size / piece_size * piece_seconds
    else
      @track['duration'] = total_seconds
    end
  end
  
  def duration
    @track['duration']
  end
  
  def size
    @track['size']
  end
  
end