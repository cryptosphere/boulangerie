require "coveralls"
Coveralls.wear!

require "timecop"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "boulangerie"

RSpec.configure(&:disable_monkey_patching!)

def fixture_path
  Pathname.new(File.expand_path("../fixtures", __FILE__))
end
