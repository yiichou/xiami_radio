require 'uri'

class Track
  def initialize(track)
    log track[:title]
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
  
  def duration(duration = nil)
    @track[:length] = duration.ceil if duration
    duration = @track[:length].to_i
  end

  def grade?
    @track[:grade].to_i == 1
  end

  def reason
    @track[:reason] ||= {:content => "来自你的音乐库"}
    
    Reason.new(@track[:reason])
  end
  
  class Reason
    def initialize(reason)
      @reason = reason
    end
    
    def content
      @reason[:content]
    end
    
    def title
      @reason[:title]
    end
    
    def artist
      @reason[:artist]
    end
    
    def url
      @reason[:title_url]
    end
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
  
  def log(s)
    XiamiFm.logger.debug("Track          #{s}")
  end
  
end