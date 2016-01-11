class Boulangerie
  module Matcher
    # Predicate matcher for 'not-before' caveats
    class NotBefore
      def call(not_before, _context)
        fail TypeError, "expected Time, got #{not_before.class}" unless not_before.is_a?(Time)
        Time.now >= not_before
      end
    end
  end
end
