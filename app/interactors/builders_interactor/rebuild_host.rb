module BuildersInteractor
  class RebuildHost
    include Interactor

    delegate :config, :to => :context

    def call
      host = context.config.droplet_ip
      builder_service = Deployer::BuilderService.new
      builder_service.build(context.config, host)
    end
  end
end
