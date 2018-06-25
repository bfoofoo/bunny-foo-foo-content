module BuildersInteractor
  class SetupBuild
    include Interactor::Organizer
    organize CreateDroplet, CreateZone, BuildHost
  end
end
