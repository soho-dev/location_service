class GoogleMapService
  class << self
    def get_address(address)
      RestClient.get(
        base_url,
        params: {
          address: address,
          key: google_api_key
        }
      )
    end

    def base_url
      "https://maps.googleapis.com/maps/api/geocode/json"
    end

    def google_api_key
      ENV["GOOGLE_MAPS_API_KEY"]
    end
  end
end
