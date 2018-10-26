module NetatlanticInteractor
  class RefreshAccountLists
    include Interactor

    delegate :account_id, :to => :context

    def call
      context.message = ""
      context.fail! if account_id.blank?
      refresh_lists()
    end

    private   

      def refresh_lists
        lists.each do |list|
          account_model.netatlantic_lists.find_or_create_by(list_id: list["ListID"]) do |list_model|
            list_model.name = list["ListName"]
          end
        end
      end

      def account_model
        begin
          @account_model ||= NetatlanticAccount.find(account_id)
        rescue => e
          context.message = "Can't find Account with id: #{account_id}."
          context.fail!
        end
      end

      def lists
        @lists ||= EmailMarketerService::Netatlantic::FetchLists.new().call()
      end

  end
end
