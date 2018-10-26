module EmailMarketerService
  module Netatlantic
    class FetchLists < EmailMarketerService::Netatlantic::BaseService
      def initialize
      end

      def call
        HTTParty.get("#{API_PATH}/lists.php")
      end
    end
  end
end