class AtmPoro
  attr_reader :id, :type, :name, :address, :lat, :lon, :distance

  def initialize(data)
    @id = data[:nothing]
    @type = data[:query]
    @name = data[:poi][:name]
    @address = data[:address][:freeformAddress]
    @lat = data[:position][:lat]
    @lon = data[:position][:lon]
    @distance = data[:dist]
  end
end