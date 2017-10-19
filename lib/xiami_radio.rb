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

  def self.mktmpdir
    Dir.mkdir TMP_DIR, 0700 unless Dir.exist? TMP_DIR
  end
end

XiamiRadio.mktmpdir