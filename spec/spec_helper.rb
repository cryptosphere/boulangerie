require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "boulangerie"

RSpec.configure(&:disable_monkey_patching!)
