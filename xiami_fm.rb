# encoding: utf-8
require_relative 'application'

# 用户的 member_auth， 可从虾米网页的 cookie 中获取
MemberAuth = "1WuYGtxL6mFvhfPCRI9kIXUY4rbTHTeBx40BirYk5AMkcYwJNteswauVRQtJ0SeVkY6wtGU1Rg"
# 是否开启 320K
HdSwitch = "on"

trap('INT') { puts "\nClosing" ; exit }

xiami = XiamiFm.new.play
