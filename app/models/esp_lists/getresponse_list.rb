class GetresponseList < EspList
  belongs_to :getresponse_account, foreign_key: :account_id
  alias_attribute :account, :getresponse_account

  validates :campaign_id, uniqueness: true
end
