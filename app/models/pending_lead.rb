class PendingLead < ApplicationRecord
  acts_as_paranoid

  PROVIDERS = %w(netatlantic adopia).freeze
  VALID_REFERRERS = %w(applyforjobs.us applyforlocaljobs.net athomeworkfinder.com benefitsguide.co creditscout.com familybenefitsnetwork.co
                       familysupportnet.com fileforunemployment.net fileforunemployment.us findfamilysupport.com findgovernmentjobs.co
                       findgovernmentjobs.info findhousingbenefits.com findlocaljobs.info findresourcehelp.net findunclaimedmoney.net
                       grantresources.org hopeforamericans.net housinggrantinfo.com jobresults.org jobs-in-my-area.net jobsinyourarea.co
                       localjobsearch.net myresourceassistant.com myresourcefinder.us offermethis.com openposition.co openposition.net
                       rent-to-own.club rent-to-own-listings.net resourcedepot.co resourcedepot.info resourcefinder.info
                       resourcefinder.us staging.findtherightschool.net theresourcefinder.net usbenefitsguide.com usrentalsource.com
                       usresourcecenter.net www.jobs-in-my-area.net www.resourcedepot.info).freeze

  PROVIDERS.each do |provider|
    scope "sent_to_#{provider}", -> { where("sent_to_#{provider}" => true) }
    scope "not_sent_to_#{provider}", -> { where("sent_to_#{provider}" => false) }
  end

  scope :with_valid_referrers, -> { where(referrer: VALID_REFERRERS) }
end