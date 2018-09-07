class Formsite
  class ConvertAdsToHashUseCase
    attr_reader :formsite

    def initialize(formsite)
      @formsite = formsite
    end

    def perform
      ads_hash
    end

    private
      def ads_hash
        formsite.ads.each_with_object({}) do |ad, memo|
          memo[ad.position] = ad
        end
      end

  end
end
