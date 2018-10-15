module Adopia
  module Resources
    class Contacts < Adopia::Resource
      def self.build(params)
        params.each_with_object({}) do |(key, value), hash|
          hash["contact[#{key}]".to_sym] = value
        end
      end
    end
  end
end
