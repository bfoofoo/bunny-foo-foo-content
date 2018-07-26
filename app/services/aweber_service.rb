require 'aweber'
class AweberService
  def initialize
    oauth = AWeber::OAuth.new('AkjqtV9OAjXAqvrRb53uLdN1', 'p71QEVG1oWSVqWfvV40oFwaNHzNag6Y13qbw53hg')
    oauth.authorize_with_access('AgXDZhnE92QzaZuRfj050cwt', 'UkfeCE2P77rHMQWxrrhc05ohAVgxPudo70xnpV6G')
    @client = AWeber::Base.new(oauth)
  end

  def get_lists
    @client.account.lists
  end
end