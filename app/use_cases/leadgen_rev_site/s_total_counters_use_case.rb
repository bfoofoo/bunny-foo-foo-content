class LeadgenRevSite
  class STotalCountersUseCase
    attr_reader :leadgen_rev_site

    def s_users_counters(leadgen_rev_site)
      handle_leadgen_rev_site(leadgen_rev_site)
      s_counters
    end

    private 
      def s_counters
        {
          "s1" => counters_by_field("s1"),
          "s2" => counters_by_field("s2"),
          "s3" => counters_by_field("s3"),
          "s4" => counters_by_field("s4"),
          "s5" => counters_by_field("s5")
        }
      end

      def counters_by_field(field)
        leadgen_rev_site_users.select {|user| !user[field].blank? }.count
      end

      def leadgen_rev_site_users
        leadgen_rev_site.leadgen_rev_site_users.without_test_users
      end

      def handle_leadgen_rev_site(leadgen_rev_site)
        if @leadgen_rev_site.blank? || (!@leadgen_rev_site.blank? && @leadgen_rev_site.id != leadgen_rev_site.id)
          @leadgen_rev_site = leadgen_rev_site
        end
        @leadgen_rev_site
      end

  end
end
