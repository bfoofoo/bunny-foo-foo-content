require 'aweber'
class AweberService
  attr_reader :client

  def initialize
  end

  def get_lists
    client.account.lists
  end

  def client(oauth)
    AWeber::Base.new(oauth) 
  end

  def account
    return @account if !@account.blank?
    @account = client.account
  end
end