class LeadgenRevSite
  class ConvertAdsToHashUseCase
    attr_reader :leadgen_rev_site

    def initialize(leadgen_rev_site)
      @leadgen_rev_site = leadgen_rev_site
    end

    def perform
      ads_hash
    end

    private
      def ads_hash
        leadgen_rev_site.ads.each_with_object({}) do |ad, memo|
          memo[ad.position] = ad
        end
      end

  end
end
