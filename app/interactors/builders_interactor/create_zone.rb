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

        zone_service.change_ssl_settings({id: zone.result[:id]})

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
      if context.config[:type] == 'website'
        droplet_service = Deployer::DigitaloceanService.new('5dcf0ee555c762983947d203009857a81dddf9811bfe7007b6bb7287069d948f')
      elsif context.config[:type] == 'formsite'
        droplet_service = Deployer::DigitaloceanService.new('e354525de2bd3d834d48693171aba6bcd87cdf945f5aef95ab9652c4c9c4b445')
      end
      droplet_service.delete_droplet({droplet_id: context.droplet[:id]})
    end
  end
end
