class Formsite
  class STotalCountersUseCase
    attr_reader :formsite

    def s_users_counters(formsite)
      formsite = handle_formsite(formsite)
      return s_couters()
    end

    private 
      def s_couters
        {
          "s1" => couters_by_field("s1"),
          "s2" => couters_by_field("s2"),
          "s3" => couters_by_field("s3"),
          "s4" => couters_by_field("s4"),
          "s5" => couters_by_field("s5")
        }
      end

      def couters_by_field field
        formsite_users.select {|user| !user[field].blank? }.count
      end

      def formsite_users
        return @formsite_users if !@formsite_users.blank?
        @formsite_users = formsite.formsite_users
      end

      def handle_formsite formsite
        if @formsite.blank? || (!@formsite.blank? && @formsite.id != formsite.id)
          @formsite = formsite
        end
        return @formsite
      end

  end
end