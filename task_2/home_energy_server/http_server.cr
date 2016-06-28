require "http/server"
require "json"

class HomeEnergyServer::HttpServer
  def initialize(@port = 3080, @h : HomeServer = HomeServer.new)
    @server = HTTP::Server.new(@port) do |context|
      context.response.content_type = "application/json"
      context.response.print @h.payload.to_json
    end

  end

  def make_it_so
    @server.listen
  end
end
