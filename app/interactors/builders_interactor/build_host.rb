module BuildersInteractor
  class BuildHost
    include Interactor

    delegate :config, :to => :context
    delegate :droplet, :to => :context
    delegate :zone, :to => :context

    def call
      begin
        host = context.droplet.networks[:v4][0][:ip_address]
        builder_service = Deployer::BuilderService.new
        builder_service.setup(context.config, host)
      rescue => e
        context.errors = [e.message]
        context.fail!
      end
    end

    def rollback
      if context.config[:type] == 'website'
        droplet_service = Deployer::DigitaloceanService.new('5dcf0ee555c762983947d203009857a81dddf9811bfe7007b6bb7287069d948f')
      elsif context.config[:type] == 'formsite'
        droplet_service = Deployer::DigitaloceanService.new('e354525de2bd3d834d48693171aba6bcd87cdf945f5aef95ab9652c4c9c4b445')
      end
      zone_service = Deployer::CloudflareService.new

      droplet_service.delete_droplet({droplet_id: context.droplet[:id]})
      zone_service.delete_zone({zone_id: context.zone[:id]})
    end
  end
end
