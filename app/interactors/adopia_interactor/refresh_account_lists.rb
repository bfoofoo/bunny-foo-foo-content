module AdopiaInteractor
  class RefreshAccountLists
    include Interactor

    delegate :account_id, to: :context

    def call
      context.message = ''
      refresh_lists
    end

    private

    def refresh_lists
      lists.each do |list|
        account.lists.find_or_create_by(list_id: list.id) do |item|
          item.name = list.name
        end
      end
    end

    def account
      @account ||= AdopiaAccount.find(account_id)
    rescue ActiveRecord::RecordNotFound => e
      context.message = "Can't find Adopia account with id: #{account_id}."
      context.fail!
    end

    def client
      return @client if defined?(@client)
      @client = ::Adopia::Client.new(account.api_key)
    end

    def lists
      @lists ||= client.pull_user_lists
    end

  end
end
