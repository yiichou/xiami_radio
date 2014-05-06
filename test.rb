# encoding : utf-8
require 'nokogiri'
require 'open-uri'

#example：baidu encoding：GB2312

html=open("http://dota2.uuu9.com/List/List_7609.shtml").read
html = html.gsub(/\<\!--*--\>/, "")
puts html
# charset=Nokogiri::HTML(html).meta_encoding#！有些网页没有定义charset则不适用
# puts charset
# html.force_encoding(charset)
# html.encode!("utf-8", :undef => :replace, :replace => "?", :invalid => :replace)
# doc = Nokogiri::HTML.parse html
# puts doc