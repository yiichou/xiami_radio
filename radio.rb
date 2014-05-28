require 'net/http'
require 'json'
require 'nori'

class Radio
  
  attr_reader :list
  
  def initialize
    @headers = {
    "Accept" => "*/*",
    "Accept-Encoding" => "text/html",
    "Accept-Language" => "en-US,en;q=0.8,zh;q=0.6,zh-TW;q=0.4",
    "Cookie" => "member_auth=#{MemberAuth}",
    "Referer" => "http://www.xiami.com/radio/play/id/2",
    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36"
    }
  
    res = request(URI.parse("http://www.xiami.com/index/home"))
    if (res.code == '200')
      all_cookies = res.get_fields('set-cookie')
      @cookies = Array.new
      all_cookies.each { | cookie | @cookies.push(cookie.split('; ')[0]) }
      @headers['Cookie'] = @cookies.join('; ')
    end
  end
  
  def request(url)
    # 抓包测试
    # Net::HTTP.new(url.host,nil,'127.0.0.1','8889').start do |http|
    Net::HTTP.start(url.host) do |http|
      http.request(Net::HTTP::Get.new(url, @headers))
    end
  end
  
  def get
    log 'get-list'
    url = URI.parse("http://www.xiami.com/radio/xml/type/8/id/0?v=#{Time.now.to_i}")
    res = request(url)
    
    # 解析从 Anroid API 获取的json
    # queue = res.code == '200' ? JSON.parse(res.body) : []
    # @list = queue['status'] == 'ok' ? queue['radio']['songs'] : nil
    
    # 解析从 web 获取的 XML
    nori = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
    hash = nori.parse(res.body)
    @list = hash[:play_list][:track_list][:track]
  end
  
  def get_hd(track_id)
    url = URI.parse("http://www.xiami.com/song/gethqsong/sid/#{track_id}")
    res = request(url)
    hash = JSON.parse(res.body) if res.code == '200'
    hash['location']
  end
  
  def fav(track_id)
    log "add-to-favorite"
    url = URI.parse("http://www.xiami.com/song/fav?ids=#{track_id}&_xiamitoken=#{@cookies[0]}")
    request(url)
  end
  
  def record(track_id)
    url = URI.parse("http://www.xiami.com/count/playrecord?sid=#{track_id}&type=10&ishq=1")
    res = request(url)
    log "record-limited" unless res.code == "200"
  end
  
  def log(s)
    XiamiFm.logger.debug("Raido          #{s}")
  end
  
end