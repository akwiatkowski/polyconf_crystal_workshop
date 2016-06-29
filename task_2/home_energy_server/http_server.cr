require "http/server"
require "json"

class HomeEnergyServer::HttpServer
  def initialize(@port = 3080, @h : HomeServer = HomeServer.new)
    @server = HTTP::Server.new("0.0.0.0", @port) do |context|
      context.response.content_type = "application/json"

      if context.request.method == "POST"
        r = process_post_request(context)
        context.response.print r.to_json
      else
        context.response.print @h.payload.to_json
      end
    end

  end

  def make_it_so
    @server.listen
  end

  def process_post_request(context)
    begin
      req = JSON.parse(context.request.body.to_s)
      if req["reset_battery"]?
        @h.reset_battery
        return {status: 0}
      end

      if req["name"]?
        outlet = @h.add_power_outlet(name: req["name"].to_s, power: req["power"].to_s.to_f)
        return {status: 0, outlet: outlet.payload}
      end

      return @h.payload
    rescue JSON::ParseException
      return nil
    end

  end
end
