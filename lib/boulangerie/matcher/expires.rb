class Boulangerie
  module Matcher
    # Predicate matcher for 'expires' caveats
    class Expires
      def call(expires_at, _context)
        fail TypeError, "expected Time, got #{expires_at.class}" unless expires_at.is_a?(Time)
        Time.now < expires_at
      end
    end
  end
end
