class AddressParamsConverter

  def initialize(address)
    @address = address
  end

  def format
    results  = AddressLookup.lookup(@address)
  end

  private

    def sample_addresses
      YAML.load_file('config/fixtures/addresses.json')
    end
end
