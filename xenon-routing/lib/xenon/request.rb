require 'xenon/headers'

module Xenon
  class Request
    attr_accessor :unmatched_path

    def initialize(rack_req)
      @rack_req = rack_req
      @unmatched_path = rack_req.path.freeze
    end

    def request_method
      @rack_req.request_method.downcase.to_sym
    end

    def form_hash
      @form_hash ||= @rack_req.POST.with_indifferent_access.freeze
    end

    def param_hash
      @param_hash ||= @rack_req.GET.with_indifferent_access.freeze
    end

    def cookie(name)
      @rack_req.cookies[name]
    end

    def header(name)
      snake_name = name.to_s.tr('-', '_').upcase
      value = @rack_req.env['HTTP_' + snake_name] || @rack_req.env[snake_name]
      return nil if value.nil?

      klass = Xenon::Headers.header_class(name)
      klass ? klass.parse(value) : Xenon::Headers::Raw.new(name, value)
    end

    def body
      @rack_req.body
    end

    def copy(changes = {})
      r = dup
      changes.each { |k, v| r.instance_variable_set("@#{k}", v.freeze) }
      r
    end
  end
end
