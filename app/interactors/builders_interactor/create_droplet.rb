module BuildersInteractor
  class CreateDroplet
    include Interactor

    delegate :config, :to => :context
    delegate :droplet, :to => :context
    delegate :zone, :to => :context

    def call
      begin
        droplet_service = if config.type == 'website'
          Deployer::DigitaloceanService.new('5dcf0ee555c762983947d203009857a81dddf9811bfe7007b6bb7287069d948f')
        elsif config.type == 'formsite'
          Deployer::DigitaloceanService.new('e354525de2bd3d834d48693171aba6bcd87cdf945f5aef95ab9652c4c9c4b445')
        end
        droplet = droplet_service.setup_droplet({name: context.config[:name]})
        context.droplet = droplet_service.get_droplet(droplet[:id])
        Rails.logger.info 'Droplet created'
        sleep 10
        while context.droplet.networks[:v4].length == 0 do
          sleep 5
          context.droplet = droplet_service.get_droplet(droplet[:id])
        end
        Rails.logger.info 'Droplet loaded'
        save_droplet
        droplet
      rescue => error
        context.errors = [error.message]
        context.fail!
      end
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
