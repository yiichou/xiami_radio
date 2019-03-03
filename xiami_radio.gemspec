# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require 'xiami_radio/version'

Gem::Specification.new do |spec|
  spec.name        = 'xiami_radio'
  spec.version     = XiamiRadio::VERSION
  spec.authors     = ['Ivan Chou']
  spec.email       = ['me@ichou.cn']
  spec.license     = 'MIT'

  spec.summary     = 'a Xiami radio player by command-line on ruby'
  spec.description = 'A Xiami radio player by command-line on ruby, help you listening to the Xiami via a geek way.'
  spec.homepage    = 'https://github.com/IvanChou/xiami_radio'

  spec.files        = Dir['{lib}/**/*'] + %w[MIT-LICENSE README.md]
  spec.bindir       = 'bin'
  spec.executables  = ['xiami_radio']

  spec.add_dependency 'audite',      '~> 0.4'
  spec.add_dependency 'curses',      '~> 1.2'
  spec.add_dependency 'http-cookie', '~> 1.0'
  spec.add_dependency 'nori',        '~> 2.6'
  spec.add_dependency 'nokogiri',    '~> 1.10'
  spec.add_dependency 'daemons',     '~> 1.3'

  spec.add_development_dependency 'byebug', '~> 9.0'
end
