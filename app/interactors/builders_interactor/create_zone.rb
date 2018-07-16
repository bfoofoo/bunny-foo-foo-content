module BuildersInteractor
  class CreateZone
    include Interactor

    delegate :config, :to => :context
    delegate :droplet, :to => :context
    delegate :zone, :to => :context

    def call
      zone_service = Deployer::CloudflareService.new
      zone = zone_service.create_zone(context.config[:name])
      Rails.logger.info 'zone created'
      if zone.errors.length > 0
        context.errors = zone.errors.collect{|i| i[:message]}
        context.fail!
      else
        ip = context.droplet.networks[:v4][0][:ip_address]

        zone_service.add_dns_to_zone({id: zone.result[:id], name: zone.result[:name], ip: ip, type: "A", proxied: true, ttl: 1})
        zone_service.add_dns_to_zone({id: zone.result[:id], name: "www.#{zone.result[:name]}", ip: ip, type: "A", proxied: true, ttl: 1})

        zone_service.add_dns_to_zone({id: zone.result[:id], name: "autodiscover", ip: 'autodiscover.emailsrvr.com', type: "CNAME", proxied: true, ttl: 1})
        zone_service.add_dns_to_zone({id: zone.result[:id], name: zone.result[:name], ip: "v=spf1 include:emailsrvr.com ~all", type: "TXT"})

        zone_service.add_dns_to_zone({id: zone.result[:id], name: zone.result[:name], ip: 'mx1.emailsrvr.com', type: "MX", ttl: 60000})
        zone_service.add_dns_to_zone({id: zone.result[:id], name: zone.result[:name], ip: 'mx2.emailsrvr.com', type: "MX", ttl: 60000})

        context.zone = zone_service.get_zone(zone.result[:id])
        save_zone(zone)
      end
    end

    def save_zone(zone)
      puts "SAVE ZONE"
      if context.config[:type] == 'website'
        Website.update(context.config[:website_id], zone_id: zone.result[:id])
      else
        Formsite.update(context.config[:website_id], zone_id: zone.result[:id])
      end
    end

    def rollback
      droplet_service = Deployer::DigitaloceanService.new
      droplet_service.delete_droplet({droplet_id: context.droplet[:id]})
    end
  end
end
