class SearchService
  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def nearest_atm(lat, lon)
    get_url("?lat=#{lat}&lon=#{lon}")
  end

  def conn
    Faraday.new(url: "https://api.tomtom.com/search/2/categorySearch/atm.json") do |faraday|
      faraday.params['key'] = Rails.application.credentials.tomtom[:key]
    end
  end
end