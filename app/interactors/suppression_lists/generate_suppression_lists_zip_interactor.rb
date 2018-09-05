module SuppressionLists
  class GenerateSuppressionListsZipInteractor
    TEMP_FILE_NAME = "SuppressionListsTempFile"

    include Interactor
    delegate :params, :to => :context

    def call
      if params[:start_date].blank? || params[:end_date].blank?
        context.error_message = {
          message: "Please specify date range."
        }
        context.fail! 
      end
      context.generated_zip = generated_zip
    end

    private
      def temp_file
        @temp_file ||= Tempfile.new TEMP_FILE_NAME
      end

      def suppression_lists
        @suppression_lists ||= SuppresionList.between_dates(
          params[:start_date].to_date.beginning_of_day, params[:end_date].to_date.end_of_day
        )
      end

      def generated_zip
        Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
          suppression_lists.each do |list|
            zipfile.add list.file.file.filename, list.file.path
          end
        end
        temp_file
      end
  end
end
