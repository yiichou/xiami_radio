module XiamiRadio
  # There is a radio as you saw
  class Radio
    TRACKS_PATH = '/radio/xml/type/%{type}/id/%{oid}'
    RADIO_PATH = '/radio/play/type/%{type}/oid/%{oid}'

    XIAMI_CAI = {type: 8, oid: 0}.freeze

    attr_reader :type, :oid, :client, :nori, :play_queue

    def initialize(type:, oid:, user: nil)
      @type = type
      @oid = oid
      @client = user&.client || Client.new
      @nori = Nori.new(:convert_tags_to => -> (tag) { tag.snakecase.to_sym })
      @play_queue = []
    end

    def get_new_playlist
      tracks = client.get(uri, format: :xml, headers: headers_referer).dig(:play_list, :track_list, :track)
      tracks.map { |track| Track.new track, radio: self }
    end

    def next_track
      @play_queue += get_new_playlist if @play_queue.size < 2
      @play_queue.shift
    end

    def headers_referer
      referer = client.uri(path: RADIO_PATH % {type: type, oid: oid}).to_s
      {'Referer': referer}
    end

    private

    def uri
      client.uri path: TRACKS_PATH % {type: type, oid: oid},
                 query: URI.encode_www_form(v: Time.now.to_i)
    end
  end
end
