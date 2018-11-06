module Onepoint
  class Resource
    def initialize(api_key)
      @request = Request.new(api_key, base_path)
    end

    private

    def base_path; end
  end
end
