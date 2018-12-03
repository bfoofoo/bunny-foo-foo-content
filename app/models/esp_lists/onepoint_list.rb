class OnepointList < ApplicationRecord
  include Esp::ListMethods

  belongs_to :onepoint_account

  alias_attribute :account, :onepoint_account

  private

  def account_display_name
    account.username
  end
end
