require 'xiami_radio/client'
require 'xiami_radio/downloader'
require 'xiami_radio/notice'
require 'xiami_radio/player'
require 'xiami_radio/radio'
require 'xiami_radio/track'
require 'xiami_radio/user'
require 'xiami_radio/view/player'

require 'tmpdir'

module XiamiRadio
  TMP_DIR = File.join(Dir.tmpdir, 'xiami_radio').freeze
  DEBUG = false

  Thread.abort_on_exception = true

  class << self
    def init
      mktmpdir
      stderr = debug? ? STDOUT : File.join(TMP_DIR, '戊')
      $stderr.reopen stderr, 'w'
    end

    def mktmpdir
      Dir.mkdir TMP_DIR, 0700 unless Dir.exist? TMP_DIR
    end

    def debug?
      %w(1 true on).include? ENV.fetch('DEBUG', DEBUG)
    end
  end
end

XiamiRadio.init