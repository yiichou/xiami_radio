require 'net/http'
require 'json'
require 'nori'

class Radio
  
  attr_reader :list
  
  def initialize
    @url = URI.parse("http://www.xiami.com/radio/xml/type/8/id/0?v=#{Time.now.to_i}")
    @headers = {
    "Accept" => "*/*",
    "Accept-Encoding" => "text/html",
    "Accept-Language" => "en-US,en;q=0.8,zh;q=0.6,zh-TW;q=0.4",
    "Cookie" => "_xiamitoken=dbfe83fadfa5009fa57e297e19f9c270;sec=5362676539ab94b639d799d8125aafb30c4d80d2;member_auth=1WuYGtxL6mFvhfPCRI9kIXUY4rbTHTeBx40BirYk5AMkcYwJNteswauVRQtJ0SeVkY6wtGU1Rg",
    "Referer" => "http://www.xiami.com/radio/play/id/2",
    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36"
      }
  end
  
  def request(url = @url)
    # 抓包测试
    # Net::HTTP.new(@url.host,nil,'127.0.0.1','8889').start do |http|
    Net::HTTP.start(url.host) do |http|
      http.request(Net::HTTP::Get.new(url, @headers))
    end
  end
  
  def get
    res = request
    
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
  
end