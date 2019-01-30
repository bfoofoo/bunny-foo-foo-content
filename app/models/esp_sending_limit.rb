class EspSendingLimit < ApplicationRecord
  store_accessor :isp_limits

  PROVIDERS = %w(Adopia Allinbox Constantcontact Elite Getresponse Mailgun Netatlantic Onepoint Sparkpost Mailigen)

  validates :provider, presence: true, uniqueness: true
  validates :daily_limit, numericality: { greater_than_or_equal_to: 0 }
  validate :check_daily_limit

  def check_daily_limit
    return if isp_limits.blank?
    errors.add(:daily_limit, 'Cannot be less than any ISP limit') if isp_limits.values.max.to_i > daily_limit
  end

  def list_type
    [provider, 'List'].join
  end

  def reached?
    !daily_limit.zero? && ExportedLead.where(list_type: list_type, created_at: Date.current.beginning_of_day..Date.current.end_of_day).count >= daily_limit
  end

  def isp_limit_reached?(email)
    isp = email.split('@').last.split('.')[-2]
    exported_leads = ExportedLead.where(list_type: list_type, created_at: Date.current.beginning_of_day..Date.current.end_of_day).includes(:linkable).to_a.select do |lead|
      lead.linkable.email.split('@').last.split('.')[-2] == isp
    end
    isp_limits[isp] && exported_leads.count >= isp_limits[isp].to_i
  rescue
    false
  end
end
