module Statistics
  module EmailMarketers
    class MaropostBaseStats
      attr_reader :maropost_list_id, :start_date, :end_date

      def maropost_list
        return @maropost_list if !@maropost_list.blank?
        @maropost_list =
          if !maropost_list_id.blank?
            MaropostList.find_by(id: maropost_list_id)
          else
            maropost_lists.first
          end
      end

      private

      def maropost_lists
        return @maropost_lists if !@maropost_lists.blank?
        @maropost_lists = MaropostList.all
      end
    end
  end
end
