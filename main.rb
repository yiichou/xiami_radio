# encoding: utf-8
require_relative 'application'

module XiamiFm
  
  def self.start
    application = Application.new()

    Signal.trap('SIGINT') do
      application.stop
    end

    application.run
  end
  
  start

end