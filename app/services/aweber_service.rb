require 'aweber'
class AweberService
  attr_reader :client

  def initialize
    authorize_with_access
  end

  def get_lists
    client.account.lists
  end

  def client 
    return @client if !@client.blank?
    client = AWeber::Base.new(oauth) 
  end

  def account
    return @account if !@account.blank?
    @account = client.account
  end

  def oauth
    return @oauth if !@oauth.blank?
    @oauth = AWeber::OAuth.new(ENV["AWEBER_CONSUMER_KEY"], ENV["AWEBER_SECRET_KEY"])
  end
  private

  def authorize_with_access
    # oauth.authorize_with_verifier("58ln5q")
    oauth.authorize_with_access('AgXDZhnE92QzaZuRfj050cwt', 'UkfeCE2P77rHMQWxrrhc05ohAVgxPudo70xnpV6G')
  end
end