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
      puts 'after sleep'
      while context.droplet.networks[:v4].length == 0 do
        puts '5'
        sleep 5
        context.droplet = droplet_service.get_droplet(droplet[:id])
      end
      droplet
    end

    def isDropletInited(droplet)
      puts droplet
      droplet.networks[:v4].length > 0
    end
  end
end
