require 'uri'

class Track
  def initialize(track)
    @track = track
  end
  
  def title
    @track[:title]
  end
  
  def song_id
    @track[:song_id]
  end
  
  def album_name
    @track[:album_name]
  end
  
  def artist
    @track[:artist]
  end
  
  def location(url = nil)
    @track[:location] = url if url
    de_url(@track[:location])
  end
  
  def duration
    @track[:length]
  end
  
  protected
  
  def de_url(location)
    key = location[0].to_i
    tmp_url = location[1..location.length]
    fr = tmp_url.length.divmod(key)
    ll = []
    lu = []
    true_url = ""

    key.times do |i|
      ll << (fr[1] > 0 ? fr[0] + 1 : fr[0])
      lu << tmp_url[0,ll[i]]
      tmp_url = tmp_url[ll[i]..tmp_url.length]
      fr[1] -= 1
    end

    ll[0].times do |i|
      lu.each do |piece|
        piece[i] && true_url << piece[i] 
      end
    end

    URI.decode(true_url).gsub("^","0")
  end
  
end