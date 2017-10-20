module XiamiRadio
  class Track
    attr_reader :info, :title, :song_id, :album_name, :artist, :radio, :client

    def initialize(track, radio:)
      @info = track
      @title, @song_id, @album_name, @artist = track.values_at(:title, :song_id, :album_name, :artist)
      @radio = radio
      @client = Client.new user: User.instance
    end

    def location(hd: false)
      hd ? decode_location(hd_location) : decode_location(@info[:location])
    end

    def duration
      @info[:length].to_f > 1 ? @info[:length].to_f : (@info[:length].to_f * 1_000_000)
    end

    def duration=(duration)
      @info[:length] = duration
    end

    def grade?
      @info[:grade].to_i == 1
    end

    def reason
      @info[:reason] ||= {content: '来自电台推送'}
      OpenStruct.new @info[:reason]
    end

    def downloader
      @downloader ||= Downloader.new self
    end

    def file_path
      @info[:file_path] ||= begin
        downloader.start if downloader.file.nil?
        downloader.file.path
      end
    end

    def record
      uri = client.uri path: '/count/playrecord',
                       query: URI.encode_www_form(sid: song_id, type: 1, ishq: 1)
      client.get(uri, headers: radio.headers_referer, format: :js)
    end

    def fav
      uri = client.uri path: '/song/fav',
                       query: URI.encode_www_form(ids: song_id, _xiamitoken: client.user.xiami_token)
      res = client.get(uri, headers: radio.headers_referer, format: :js)

      return '操作失败 (╯‵□′)╯︵┻━┻' unless res.code == '200'
      grade = /player_collected\('(\d)','(\d+)'\)/.match(res.body)[1]
      grade == '1' ? '已添加到音乐库' : '已从音乐库中移除'
    end

    private

    def decode_location(location)
      key, tmp_url = location[0].to_i, location[1..location.length]
      fr, ll, lu, true_url = tmp_url.length.divmod(key), [], [], ''

      key.times do |i|
        ll << (fr[1] > 0 ? fr[0] + 1 : fr[0])
        lu << tmp_url[0,ll[i]]
        tmp_url = tmp_url[ll[i]..tmp_url.length]
        fr[1] -= 1
      end

      ll[0].times do |i|
        lu.each do |piece|
          piece[i] && true_url << piece[i]
        end
      end

      URI.decode(true_url).gsub('^', '0')
    end

    def hd_location
      @info[:hd_location] ||= begin
        uri = client.uri path: "/song/gethqsong/sid/#{song_id}"
        client.get(uri, headers: radio.headers_referer)[:location]
      end
    end
  end
end
