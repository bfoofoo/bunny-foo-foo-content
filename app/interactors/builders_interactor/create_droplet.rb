module BuildersInteractor
  class CreateDroplet
    include Interactor

    delegate :config, :to => :context
    delegate :droplet, :to => :context
    delegate :zone, :to => :context

    def call
      size = nil
      case context.config[:type]
      when 'website'
        droplet_service = Deployer::DigitaloceanService.new('5dcf0ee555c762983947d203009857a81dddf9811bfe7007b6bb7287069d948f')
        image = '35876901'
      when 'formsite'
        droplet_service = Deployer::DigitaloceanService.new('e354525de2bd3d834d48693171aba6bcd87cdf945f5aef95ab9652c4c9c4b445')
        image = '36375081'
      when 'leadgen_rev_site'
        droplet_service = Deployer::DigitaloceanService.new('268a294762b6869a3a5a6f165675642055a81f14a38c9c6647276ae9b1463310')
        image = '40070369'
        size = '1vcpu-2gb'
      end
      droplet = droplet_service.setup_droplet({name: context.config[:name], image: image, size: size})
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

    def save_droplet
      case context.config[:type]
      when 'website'
        Website.update(context.config[:website_id], droplet_id: context.droplet[:id], droplet_ip: context.droplet.networks[:v4][0][:ip_address])
      when 'formsite'
        Formsite.update(context.config[:website_id], droplet_id: context.droplet[:id], droplet_ip: context.droplet.networks[:v4][0][:ip_address])
      when 'leadgen_rev_site'
        LeadgenRevSite.update(context.config[:website_id], droplet_id: context.droplet[:id], droplet_ip: context.droplet.networks[:v4][0][:ip_address])
      end
    end

    def rollback
      case context.config[:type]
      when 'website'
        droplet_service = Deployer::DigitaloceanService.new('5dcf0ee555c762983947d203009857a81dddf9811bfe7007b6bb7287069d948f')
      when 'formsite'
        droplet_service = Deployer::DigitaloceanService.new('e354525de2bd3d834d48693171aba6bcd87cdf945f5aef95ab9652c4c9c4b445')
      when 'leadgen_rev_site'
        droplet_service = Deployer::DigitaloceanService.new('268a294762b6869a3a5a6f165675642055a81f14a38c9c6647276ae9b1463310')
      end
      droplet_service.delete_droplet({droplet_id: context.droplet[:id]})
    end
  end
end
