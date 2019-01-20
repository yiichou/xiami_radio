require 'xiami_radio/client'
require 'xiami_radio/downloader'
require 'xiami_radio/notice'
# require 'xiami_radio/player'
require 'xiami_radio/radio'
require 'xiami_radio/track'
require 'xiami_radio/user'
require 'xiami_radio/view/player'

require 'tmpdir'
require 'logger'

module XiamiRadio
  autoload :Player, 'xiami_radio/player'

  TMP_DIR = File.join(Dir.tmpdir, 'xiami_radio').freeze
  DEBUG = false

  Thread.abort_on_exception = true

  class << self
    attr_reader :logger

    def init
      mktmpdir
      $stderr.reopen File.join(TMP_DIR, '戊'), 'w'
      @logger = Logger.new File.join(TMP_DIR, '戊')
      logger.level = debug? ? :debug : :info
    end

    def mktmpdir
      Dir.mkdir TMP_DIR, 0700 unless Dir.exist? TMP_DIR
    end

    def debug?
      %w(1 true on).include? ENV.fetch('DEBUG', DEBUG)
    end

    def track_info_swap
      File.join(XiamiRadio::TMP_DIR, '庚')
    end
  end
end
