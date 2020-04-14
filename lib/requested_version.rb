class RequestedVersion
  class InvalidVersionError < StandardError; end
  class UnsupportedVersionError < StandardError; end

  ValidRegexp = /^\d+(\.\d+){0,2}$/

  attr_reader :requested

  def initialize(requested)
    @requested = requested
    raise InvalidVersionError.new("#{requested} is not a valid requested version") unless valid?
  end

  def satisfied_by?(version)
    if version.is_a?(String)
      version = Semantic::Version.new(version)
    end
    version.major == major &&
      version.satisfies?(">= #{requested}")
  end

  def major
    requested.split(".").first.to_i
  end

  def ==(other)
    other.is_a?(self.class) &&
      requested == other.requested
  end

  private

  def valid?
    requested =~ ValidRegexp
  end
end
