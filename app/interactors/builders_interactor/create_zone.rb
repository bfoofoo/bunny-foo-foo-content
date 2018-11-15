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
      case context.config[:type]
      when 'website'
        Website.update(context.config[:website_id], zone_id: zone.result[:id])
      when 'formsite'
        Formsite.update(context.config[:website_id], zone_id: zone.result[:id])
      else
        LeadgenRevSite.update(context.config[:website_id], zone_id: zone.result[:id])
      end
    end

    def rollback
      case context.config[:type]
      when 'website'
        droplet_service = Deployer::DigitaloceanService.new('5dcf0ee555c762983947d203009857a81dddf9811bfe7007b6bb7287069d948f')
      when 'formsite', 'leadgen_rev_site'
        droplet_service = Deployer::DigitaloceanService.new('268a294762b6869a3a5a6f165675642055a81f14a38c9c6647276ae9b1463310')
      end
      droplet_service.delete_droplet({droplet_id: context.droplet[:id]})
    end
  end
end
