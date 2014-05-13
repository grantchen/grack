require 'rack/builder'

module Grack
  module Bundle
    extend self

    def new(config)
      Rack::Builder.new do
        use Grack::Auth do |username, password|
          false
        end

        run Grack::Server.new(config)
      end
    end

  end
end
