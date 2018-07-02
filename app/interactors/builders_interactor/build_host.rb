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

    def rollback
      droplet_service = Deployer::DigitaloceanService.new
      zone_service = Deployer::CloudflareService.new

      droplet_service.delete_droplet({droplet_id: context.droplet[:id]})
      zone_service.delete_zone({zone_id: context.zone[:id]})
    end
  end
end
