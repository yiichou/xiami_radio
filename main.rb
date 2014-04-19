# encoding: utf-8

# def get_list
#   uri = URI.parse("http://www.xiami.com/radio/xml/type/8/id/0?v=#{Time.now.to_i}")
#   
#   Net::HTTP.start(uri.host, uri.port) do |http|
#     request = Net::HTTP::Get.new uri
#     request.add_field('Cookie','member_auth=1WuYGtxL6mFvhfPCRI9kIXUY4rbTHTeBx40BirYk5AMkcYwJNteswauVRQtJ0SeVkY6wtGU1Rg')
# 
#     response = http.request request # Net::HTTPResponse object
#     
#     #puts response.body
#   end
#   
# end

require_relative 'player'
require_relative 'track'
require_relative 'application'
require_relative 'events'

module XiamiFm
  @player = Player::new
  
  track = Track::new({'id'=>'paomo'})
  
  location = 'http://m5.file.xiami.com/712/55712/435293/1771115301_3944660_l.mp3?auth_key=4eb62d1cd78e281a243efeee2283cd08-1407513600-0-null'
  @player.play(track, location)

end