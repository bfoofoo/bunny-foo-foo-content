module BuildersInteractor
  class RebuildBuild
    include Interactor::Organizer
    organize CreateDroplet, CreateZone, RebuildHost
  end
end
