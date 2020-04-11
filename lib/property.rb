class Property

  ELIGIBLE_REGION_PATH = "config/eligible_regions"

  def initialize(formatted_address)
    @formatted_address = formatted_address
  end

  def eligible
    message = if @formatted_address.present?
      eligible_cities.include?(city) ? "address_eligible" : "address not eligible"
    else
      "address not found"
    end
    { message: message, formatted_address: formatted_address }
  end

  private
    attr_reader :formatted_address

    def eligible_cities
      eligible_counties[county].present? ? eligible_counties[county]["Cities"] : []
    end

    def eligible_counties
      @eligible_counties ||= YAML.load_file("#{ELIGIBLE_REGION_PATH}/ca.yml")["Counties"]
    end

    def county
      formatted_address["county"]
    end

    def city
      formatted_address["city"]
    end
end
