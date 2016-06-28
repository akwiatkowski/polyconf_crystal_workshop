class HomeEnergyServer::Wind
  def initialize(@time : HomeEnergyServer::CurrentTime)
    @speed = 0.0
  end
end
