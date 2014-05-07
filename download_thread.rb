require 'net/http'

class DownloadThread
  attr_reader :events, :url, :progress, :total, :file
  
  def initialize(url, filename)
    @url = URI.parse(url)
    @file = File.open(filename, "w")
    @progress = 0
    start!
  end
  
  def start!
    @thread = Thread.start do
      begin
        log :start
        Net::HTTP.get_response(@url) do |res|
          log "response: #{res.code}"
          raise res.body if res.code != '200'
          
          @total = res.header['Content-Length'].to_i
          
          res.read_body do |chunk|
            @progress += chunk.size
            @file << chunk
            @file.close if @progress == @total
          end
        end
      rescue => e
        log e.message
      end
    end
    
    sleep 0.1 while @total.nil?
    sleep 0.1
    
    self
  end
  
  def stop
    @thread && @thread.exit
    @thread = nil
    File.delete(@file)
  end
    
  
  def log(s)
    XiamiFm.logger.debug("DownloadThread #{s}")
  end
  
end
