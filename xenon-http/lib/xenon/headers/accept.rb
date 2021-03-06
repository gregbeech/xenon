require 'xenon/headers'
require 'xenon/parsers/header_rules'
require 'xenon/parsers/media_type'

module Xenon
  class Headers
    # http://tools.ietf.org/html/rfc7231#section-5.3.2
    class Accept < ListHeader 'Accept'
      def initialize(*media_ranges)
        super(media_ranges.sort_by.with_index { |mr, i| [mr, -i] }.reverse)
      end

      alias_method :media_ranges, :values

      def self.parse(s)
        tree = Parsers::AcceptHeader.new.parse(s)
        Parsers::AcceptHeaderTransform.new.apply(tree)
      end
    end
  end

  module Parsers
    class AcceptHeader < Parslet::Parser
      include HeaderRules, MediaTypeRules
      rule(:accept) { (media_range >> (list_sep >> media_range).repeat).as(:accept) }
      root(:accept)
    end

    class AcceptHeaderTransform < MediaTypeTransform
      rule(accept: sequence(:mr)) { Headers::Accept.new(*mr) }
      rule(accept: simple(:mr)) { Headers::Accept.new(mr) }
    end
  end
end