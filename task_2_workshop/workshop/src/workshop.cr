require "kemal"

def get_from_server
  # 150.254.82.201:3080
  response = HTTP::Client.get "http://75b39b52.ngrok.io"
   body = response.body
   json = JSON.parse(body)
   json
end

get "/" do
  json = get_from_server
  time = Time.epoch(json["time"].to_s.to_i)
  solar_power = json["solar"]["power"].to_s.to_f
  wind_power = json["wind"]["power"].to_s.to_f

  
  render "src/views/root.ecr", "src/views/layout.ecr"
end

post "/set" do |env|
  name = env.params.body["name"].to_s
  power = env.params.body["power"].to_s.to_f

  response = HTTP::Client.post("http://75b39b52.ngrok.io", nil, {"name" => name, "power" => power}.to_json)
  body = response.body
  json = JSON.parse(body)

  env.redirect "/"
end

Kemal.run
