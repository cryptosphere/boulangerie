require "boulangerie/version"

require "boulangerie/maker"
require "boulangerie/predicates/time"
require "boulangerie/predicates/time_after"
require "boulangerie/predicates/time_before"
require "boulangerie/schema"

# An opinionated library for creating and verifying Macaroons in Ruby
module Boulangerie
  # Raised if Boulangerie's global maker hasn't been configured
  NotConfiguredError = Class.new(StandardError)

  # Default Boulangerie::Maker
  @default = nil

  def self.setup(options)
    @default = Maker.new(options)
  end

  def self.default
    fail NotConfiguredError, "not configured yet, call #{self}.setup" unless @default
    @default
  end
end
