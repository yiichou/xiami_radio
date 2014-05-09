# encoding: utf-8

#---------------------------------------------------------------
# OSX Install
# brew install portaudio
# brew install mpg123
#
# Debian / Ubuntu Install
# apt-get install libjack0 libjack-dev
# apt-get install libportaudiocpp0 portaudio19-dev libmpg123-dev
#---------------------------------------------------------------

require_relative 'application'

# 用户的 member_auth， 可从虾米网页的 cookie 中获取
MemberAuth = #ur_member_auth_code#

trap('INT') { puts "\nClosing" ; exit }

xiami = XiamiFm.new.play
