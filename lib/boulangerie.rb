require "boulangerie/version"

require "boulangerie/schema"

# An opinionated library for creating and verifying Macaroons in Ruby
class Boulangerie
  # Raised if Boulangerie's global maker hasn't been configured
  NotConfiguredError = Class.new(StandardError)

  # Default Boulangerie
  @default = nil

  def self.setup(options)
    @default = new(options)
  end

  def self.default
    fail NotConfiguredError, "not configured yet, call #{self}.setup" unless @default
    @default
  end

  # TODO: do something with options
  def initialize(_options = {})
  end
end
