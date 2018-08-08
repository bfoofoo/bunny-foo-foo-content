module AweberInteractor
  class AddAccountOrganizer
    include Interactor::Organizer
    organize UpsertAccount, RefreshAccountLists
  end
end
