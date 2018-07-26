module Admin
  module FormBuilders
    class Website
      attr_reader :form

      def initialize(form)
        @form = form
      end

      def ads_nested_fields(field, params, positions:[], types:[]) 
        form.has_many field, params do |ff|
          ff.semantic_errors
          ff.input :position, :as => :select, :collection => positions
          ff.input :variety, :as => :select, :collection => types
          ff.input :widget
          ff.input :google_id, :label => 'Google ID'
          ff.input :innerHTML
        end
      end
    end
  end
end
