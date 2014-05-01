require 'net/http'
require 'json'

class Radio
  
  attr_reader :list
  
  def initialize
    @url = URI.parse('http://www.xiami.com/app/android/radio?id=2')
  end
  
  def get_list
    Net::HTTP.get_response(@url) do |res|
       hash = JSON.parse(res.body)
       @list = hash['radio']['songs']
    end
    
    @list
  end
  
end