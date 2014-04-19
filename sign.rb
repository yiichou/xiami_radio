# encoding: utf-8
require 'rubygems'
require 'mechanize'
require 'rufus-scheduler'

@s = Rufus::Scheduler.new
@users = [
  {'id' => 'me@ichou.cn', 'pwd' => '6542198', 'time' => '19:58:13'}
]

@users.each { |user|
  @s.every '1m', :first_at => user['time'] do
    puts Time.now
    sign(user)
    puts "=================================\n"
  end
}

def sign (user)
  a = Mechanize.new 
  a.user_agent_alias = 'Mac Safari'
  
  # Rythem 抓包测试代理
  #a.set_proxy('127.0.0.1', '8889')
  
  # login_page
  login_page = a.get('https://login.xiami.com/member/login')
  login_page.form.email = user['id']
  login_page.form.password = user['pwd']
  a.submit(login_page.form, login_page.form.buttons.first)
  
  # signin
  a.request_headers = {'X-Requested-With' => 'XMLHttpRequest'}
  a.get("http://www.xiami.com/index/home?_=#{Time.now.to_i}")
  my_page = a.post('http://www.xiami.com/task/signin')
  a.request_headers = {'X-Requested-With' => nil}

  # logout
  logout_page = a.get('http://www.xiami.com/member/logout')

  # puts info
  puts "Today is the #{my_page.body} day under signed of #{user['id']}"
  
end

@s.join