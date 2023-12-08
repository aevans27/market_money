class SearchFacade
  def nearest_atm(lat, lon)
    service = SearchService.new
    data = service.nearest_atm(lat, lon)
    results = data[:results].map do |atm_data|
      AtmPoro.new(atm_data)
    end
    results
  end
end