module BuildersInteractor
  class RebuildHost
    include Interactor

    delegate :config, :to => :context

    def call
      begin
        host = context.config[:droplet_ip]
        builder_service = Deployer::BuilderService.new
        builder_service.rebuild(context.config, host)
      rescue => e
        context.errors = [e.message]
        context.fail!
      end
    end
  end
end
