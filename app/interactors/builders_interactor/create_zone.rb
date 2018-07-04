module BuildersInteractor
  class CreateZone
    include Interactor

    delegate :config, :to => :context
    delegate :droplet, :to => :context
    delegate :zone, :to => :context

    def call
      zone_service = Deployer::CloudflareService.new
      zone = zone_service.create_zone(context.config[:name])
      puts 'before error'
      if zone.errors.length > 0
        puts 'in error'
        binding.pry
        context.errors = zone.errors.collect{|i| i[:message]}
        context.fail!
      else
        puts 'no error'
        ip = context.droplet.networks[:v4][0][:ip_address]
        puts 'zone id'
        puts zone.result[:id]
        zone_service.add_dns_to_zone({id: zone.result[:id], name: zone.result[:name], ip: ip})
        res = zone_service.add_dns_to_zone({id: zone.result[:id], name: "www.#{zone.result[:name]}", ip: ip})
        context.zone = zone_service.get_zone(res.result[:id])
        save_zone(res)
      end
      puts 'aftre error'
    end

    def save_zone(zone)
      puts "SAVE ZONE"
      puts zone.result[:id]
      Website.update(context.config[:website_id], zone_id: zone.result[:id])
    end

    def rollback
      droplet_service = Deployer::DigitaloceanService.new
      droplet_service.delete_droplet({droplet_id: context.droplet[:id]})
    end
  end
end
