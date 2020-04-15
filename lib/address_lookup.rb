class AddressLookup

  class << self
    def lookup(address)
      result = get_from_cache(address)
      return JSON.parse(result) if result.present?
      result = ENV["USE_GOOGLE_MAPS_API"] == "true" ? lookup_in_google_maps(address) : get_mock_address_response(address)
      put_in_cache(address, result) unless result.blank?
      result
    end

    private
      def get_from_cache(address)
        AddressCache.get(address)
      end

      def lookup_in_google_maps(address)
        result = GoogleMapService.get_address(address)
        formatted_result(result) unless JSON.parse(result.body)["results"].blank?
      end

      def formatted_result(result)
        address_hash = {}
        streat_components = []
        address_components = result["results"].first["address_components"]
        address_components.each do |component|
          case component["types"].first
          when "street_number"
            streat_components.push(component["long_name"])
          when "route"
            streat_components.push(component["long_name"])
          when "administrative_area_level_2"
            address_hash[:county] = component["long_name"].remove(" County")
          when "administrative_area_level_1"
            address_hash[:state] = component["long_name"]
          when "country"
            address_hash[:country] = component["long_name"]
          when "postal_code"
            address_hash[:zip_code] = component["long_name"]
          end
        end
        address_hash[:street] = streat_components.join(" ")
        return address_hash
      end

      def put_in_cache(address, result)
        AddressCache.set(address, result.to_json)
      end

      def get_mock_address_response(address)
        sample_addresses[address]
      end

      def sample_addresses
        YAML.load_file("#{Rails.root}/config/fixtures/addresses.json")
      end
  end
end
