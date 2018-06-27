module BuildersInteractor
  class BuildHost
    include Interactor

    delegate :config, :to => :context
    delegate :droplet, :to => :context
    delegate :zone, :to => :context

    def call
      host = context.droplet.networks[:v4][0][:ip_address]
      builder_service = Deployer::BuilderService.new
      builder_service.setup(context.config, host)
    end
  end
end
