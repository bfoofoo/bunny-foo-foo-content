module Allinbox
  class Resource


    def initialize(api_key)
      @request =  Request.new(api_key)
    end

    private
    def base_path; end
  end
end
