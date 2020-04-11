class AddressParamsConverter

  def initialize(address)
    @address = address
  end

  def format
    # call here to google api
    return sample_addresses[@address]
  end

  private

    def sample_addresses
      YAML.load_file('config/fixtures/addresses.json')
    end
end
