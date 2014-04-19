require 'logger'

module XiamiFm
  class Application
    def self.logger
      @logger ||= Logger.new('debug.log')
    end
  end
end