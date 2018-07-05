module BuildersInteractor
  class CreateDroplet
    include Interactor

    delegate :config, :to => :context
    delegate :droplet, :to => :context
    delegate :zone, :to => :context

    def call
      droplet_service = Deployer::DigitaloceanService.new
      droplet = droplet_service.setup_droplet({name: context.config[:name]})
      context.droplet = droplet_service.get_droplet(droplet[:id])

      sleep 10
      while context.droplet.networks[:v4].length == 0 do
        sleep 5
        context.droplet = droplet_service.get_droplet(droplet[:id])
      end
      save_droplet
      droplet
    end

    def save_droplet
      if context.config[:type] == 'website'
        Website.update(context.config[:website_id], droplet_id: context.droplet[:id], droplet_ip: context.droplet.networks[:v4][0][:ip_address])
      else
        Formsite.update(context.config[:website_id], droplet_id: context.droplet[:id], droplet_ip: context.droplet.networks[:v4][0][:ip_address])
      end
    end

    def rollback
      droplet_service = Deployer::DigitaloceanService.new
      droplet_service.delete_droplet({droplet_id: context.droplet[:id]})
    end
  end
end
