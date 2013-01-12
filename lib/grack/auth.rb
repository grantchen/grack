require 'rack/auth/basic'
require 'rack/auth/abstract/handler'
require 'rack/auth/abstract/request'

module Grack
  class Auth < Rack::Auth::Basic
    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      @auth = Request.new(env)

      return unauthorized unless @auth.provided?
      return bad_request unless @auth.basic?

      case valid?
      when true
        @env['REMOTE_USER'] = @auth.username
        @app.call(env)
      when '404'
        return render_not_found
      when '403'
        return render_no_access
      else# aka. false
        return unauthorized
      end
    end# method call

    def valid?
      false
    end

    PLAIN_TYPE = {"Content-Type" => "text/plain"}

    def render_method_not_allowed
      if @env['SERVER_PROTOCOL'] == "HTTP/1.1"
        [405, PLAIN_TYPE, ["Method Not Allowed"]]
      else
        [400, PLAIN_TYPE, ["Bad Request"]]
      end
    end

    def render_not_found
      [404, PLAIN_TYPE, ["Not Found"]]
    end

    def render_no_access
      [403, PLAIN_TYPE, ["Forbidden"]]
    end
  end# class Auth
end# module Grack
