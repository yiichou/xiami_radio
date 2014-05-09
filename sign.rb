# encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'rufus-scheduler'

@a = Mechanize.new
@s = Rufus::Scheduler.new
@l = Logger.new('log.txt')

@a.user_agent_alias = 'Mac Safari'
@a.request_headers = {'X-Requested-With' => 'XMLHttpRequest'}
@l.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}:#{msg}\n"
end

@users = [
  {:id => '某虫', :cookie => 'sign_ichou.yaml'}
]

@users.each { |user|
  # 设定初次签到的时间
  @s.every '1d', :first => '2014-xx-xx xx:xx:xx'  do
    sign(user)
  end
}

def sign (user)
  # Rythem 抓包测试代理
  # @a.set_proxy('127.0.0.1', '8889')
  
  # login
  tmp = @a.get('http://www.xiami.com/index/home')
  if tmp.body.length < 200
    @a.cookie_jar.load(user[:cookie])
    @a.get('http://www.xiami.com/index/home')
    @a.get("http://www.xiami.com/index/home?_=#{Time.now.to_i}")
  end

  # signin
  my_page = @a.post('http://www.xiami.com/task/signin')

  # logout
  # logout_page = @a.get('http://www.xiami.com/member/logout')

  # puts info
  @l.info("Today is the #{my_page.body} day under signed of #{user[:id]}")

end

@s.join