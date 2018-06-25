module BuildersInteractor
  class CreateZone
    include Interactor

    delegate :config, :to => :context
    delegate :droplet, :to => :context
    delegate :zone, :to => :context

    def call
      zone_service = Deployer::CloudflareService.new
      zone = zone_service.create_zone(context.config[:name])
      ip = context.droplet.networks[:v4][0][:ip_address]
      zone_service.add_dns_to_zone({id: zone.result[:id], name: zone.result[:name], ip: ip})
      res = zone_service.add_dns_to_zone({id: zone.result[:id], name: "www.#{zone.result[:name]}", ip: ip})
      context.zone = zone_service.get_zone(res.result['id'])
    end
  end
end
