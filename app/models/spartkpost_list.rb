class SpartkpostList
  include Esp::ListMethods

  belongs_to :sparkpost_account

  alias_method :account, :sparkpost_account

  private

  def account_display_name
    account.username
  end
end