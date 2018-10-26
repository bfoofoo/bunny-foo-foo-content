module Adopia
  module Resources
    class Lists < Adopia::Resource
      def collection
        return [] if collection_root.to_a.empty?
        collection_root.map do |list|
          OpenStruct.new(list[:list])
        end
      end

      def collection_root
        data&.[](:lists)
      end
    end
  end
end
