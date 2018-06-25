module Deployer
  class DigitaloceanService
    def initialize
      @client = DropletKit::Client.new(access_token: ENV['DIGITALOCEAN_KEY'])
    end

    def setup_droplet(options)
      droplet = DropletKit::Droplet.new(
          name: options[:name],
          region: options[:region] || 'nyc1',
          image: '35286581',
          size: 's-2vcpu-4gb'
      )
      @client.droplets.create(droplet)
    end

    def get_droplet(id)
      @client.droplets.find(id: id)
    end

    def get_snapshot(id)
      @client.snapshots.find(id: id)
    end
  end
end