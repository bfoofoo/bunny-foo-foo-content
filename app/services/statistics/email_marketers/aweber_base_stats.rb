module Statistics
  module EmailMarketers
    class AweberBaseStats
      attr_reader :aweber_list_id, :start_date, :end_date

      def aweber_list
        return @aweber_list if !@aweber_list.blank?
        @aweber_list =
          if !aweber_list_id.blank?
            AweberList.find_by(id: aweber_list_id)
          else
            aweber_lists.first
          end
      end

      private

      def aweber_lists
        return @aweber_lists if !@aweber_lists.blank?
        @aweber_lists = AweberList.all
      end
    end
  end
end
