module Ongage
  class Resource
    def initialize(auth_headers)
      @request = Request.new(auth_headers, base_path)
    end

    private

    def base_path; end
  end
end
