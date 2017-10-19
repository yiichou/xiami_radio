require 'net/http'

module XiamiRadio
  class Downloader
    class << self
      def circulator
        @circulator ||= Queue.new
        %w(甲 乙).map(&@circulator.method(:push)) if @circulator.empty?
        @circulator
      end
    end

    attr_reader :track, :progress, :total, :file

    def initialize(track)
      @track = track
      @uri = URI @track.location
    end

    def filename
      File.join XiamiRadio::TMP_DIR, self.class.circulator.pop(true)
    end

    def progress
      (@progress.to_f / @total.to_f).round(2) unless @progress.nil?
    end

    def start
      @thread = Thread.start do
        Net::HTTP.get_response @uri do |res|
          if res.code == '302'
            @uri = URI res.header['Location']
            start
          else
            @progress, @total = 0, res.header['Content-Length'].to_i
            @file = File.open(filename, 'w')
            res.read_body do |chunk|
              @file << chunk
              @progress += chunk.size
              @file.close unless @progress < @total
            end
          end
        end
      end
      sleep 0.1 until @progress.to_i > 0
    end

    def stop
      @thread&.exit
      @thread = nil
      File.delete(@file)
    end

  end
end
