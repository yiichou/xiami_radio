require 'net/http'
require 'json'
require 'nori'
require 'http-cookie'

module XiamiRadio
  # There is a client as you saw
  class Client
    HOST = 'https://www.xiami.com'.freeze
    LOGIN_HOST = 'https://login.xiami.com'.freeze
    HEADERS = {
      'Accept' => '*/*',
      'Accept-Encoding' => '*',
      'Accept-Language' => 'en-US,en;q=0.8,zh;q=0.6,zh-TW;q=0.4',
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36'
    }.freeze

    attr_accessor :user, :headers, :http

    def initialize(headers: {}, user: nil, host: HOST)
      @user = user || User.new
      @headers = HEADERS.merge headers
      @uri = URI.parse host

      # @http = Net::HTTP.new(@uri.host, @uri.port, '127.0.0.1', '8888')
      @http = Net::HTTP.new @uri.host, @uri.port
      @http.use_ssl = @uri.scheme == 'https'
    end

    def uri(**args)
      @uri.class.build scheme: @uri.scheme, host: @uri.host, **args
    end

    def get(uri, format: :json, headers: {})
      request uri, format, headers do |_headers|
        @http.start { |http| http.request(Net::HTTP::Get.new uri, _headers) }
      end
    end

    def post(uri, form_data, format: :json, headers: {})
      request uri, format, headers do |_headers|
        req = Net::HTTP::Post.new uri, _headers
        req.set_form_data form_data
        @http.start { |http| http.request req }
      end
    end

    private

    def request(uri, format, headers, &block)
      _headers = @headers.merge headers
      _headers.merge! 'Cookie' => HTTP::Cookie.cookie_value(user.cookie_jar.cookies uri)
      _headers.merge! 'X-Requested-With' => 'XMLHttpRequest' if %i(json xml xhtml).include? format

      res = block.call _headers

      res.get_fields('set-cookie')&.each { |value| user.cookie_jar.parse value, uri }
      case format
        when :json then JSON.parse(res.body, symbolize_names: true)
        when :xml then nori.parse res.body
        else res
      end
    end

    def nori
      @nori ||= Nori.new(:convert_tags_to => -> (tag) { tag.snakecase.to_sym })
    end
  end
end
