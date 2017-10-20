require 'http-cookie'
require 'singleton'

module XiamiRadio
  # There is a user as you saw
  class User
    include Singleton
    attr_reader :nick_name, :level, :user_id, :sign, :is_vip
    attr_accessor :cookie_jar

    def initialize
      @cookie_jar = HTTP::CookieJar.new
      @cookie_jar.load cookie_file if File.exist? cookie_file
      get_user_info
    end

    def login?
      !user_id.to_s.empty?
    end

    def login_by_email(email, password)
      page_uri = login_client.uri(path: '/member/login')
      form_uri = login_client.uri(path: '/passport/login')
      login_client.get page_uri, format: :html
      form_data = {
        _xiamitoken: xiami_token,
        done: 'http%3A%2F%2Fwww.xiami.com%2F%2F',
        verifycode: '',
        account: email,
        pw: password,
        submit: '登录'
      }
      login_client.post form_uri, form_data, headers: {
        'Content-Type' =>	'application/x-www-form-urlencoded; charset=UTF-8',
        'Referer' => page_uri.to_s
      }
      @cookie_jar.save cookie_file
      get_user_info
    end

    def login_by_member_auth(member_auth)
      uri = client.uri path: '/index/home'
      @cookie_jar.parse "member_auth=#{member_auth}; path=/; domain=.xiami.com", uri
      client.get uri, format: :head
      @cookie_jar.save cookie_file
      get_user_info
    end

    def xiami_token
      cookie_jar.cookies.select { |c| c.name == '_xiamitoken' }.first&.value
    end

    private

    def client
      @client ||= Client.new user: self
    end

    def login_client
      @l_client ||= Client.new user: self, host: Client::LOGIN_HOST
    end

    def get_user_info
      update client.get(client.uri path: '/index/home').dig(:data, :userInfo)
      Notice.push "欢迎归来 #{nick_name}，当前已连续签到 #{sign[:persist_num]} 天", 10 if login?
    end

    def update(attrs)
      return false unless attrs.is_a? Hash
      @nick_name, @level, @user_id, @sign, @is_vip = attrs.values_at :nick_name, :level, :user_id, :sign, :isVip
      true
    end

    def cookie_file
      File.join XiamiRadio::TMP_DIR, '己'
    end
  end
end