class Property

  ELIGIBLE_REGION_PATH = "config/eligible_regions"

  def initialize(formatted_address)
    @formatted_address = formatted_address
  end

  def eligible
    message = if @formatted_address.present?
      eligible_cities.include?(city) ? "address is eligible" : "address not eligible"
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
      @eligible_counties ||= eligible_states["Counties"] if eligible_states.present?
    end

    def eligible_states
      YAML.load_file("#{ELIGIBLE_REGION_PATH}/#{state}.yml")
    end

    def county
      formatted_address["county"]
    end

    def city
      formatted_address["city"]
    end

    def state
      formatted_address["state"]
    end
end
