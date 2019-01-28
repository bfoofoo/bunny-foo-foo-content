module Onepoint
  class Resource
    def initialize(api_key)
      @request = Request.new(api_key, base_path)
    end

    def with_retry
      retries ||= 0
      yield
    rescue Net::ReadTimeout
      retries += 1
      retry if retries < 3
    end

    private

    def base_path
      nil
    end
  end
end
