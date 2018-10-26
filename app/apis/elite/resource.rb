module Elite
  class Resource
    attr_reader :request

    def initialize(api_key)
      @request = Request.new(api_key, base_path)
    end

    private

    def base_path
      self.class.name.demodulize
    end

    # get camelcase version of (caller) method name
    def self_path
      caller_locations(1,1)[0].label.to_s.camelize
    end
  end
end
