# encoding: utf-8
require_relative 'application'

# 用户的 member_auth， 可从虾米网页的 cookie 中获取
MemberAuth = #ur_member_auth_code#
# 是否开启 320K
HdSwitch = "off"
# 个人音乐库 or 虾米猜
XiamiCai = "on"

trap('INT') { puts "\nClosing" ; exit }

xiami = XiamiFm.new.play
