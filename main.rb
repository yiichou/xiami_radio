# encoding: utf-8
require_relative 'application'

trap('INT') { puts "\nClosing" ; exit }

xiami = XiamiFm.new

xiami.play
