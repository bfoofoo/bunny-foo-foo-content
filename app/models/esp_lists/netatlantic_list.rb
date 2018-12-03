class NetatlanticList < ApplicationRecord
  include Esp::ListMethods

  belongs_to :netatlantic_account

  alias_attribute :account, :netatlantic_account

  private

  def account_display_name
    account.account_name
  end
end
