module Deployer
  class DigitaloceanService
    def initialize(token)
      # @client = DropletKit::Client.new(access_token: 'ENV['DIGITALOCEAN_KEY']')
      @client = DropletKit::Client.new(access_token: token)
    end

    def setup_droplet(options)
      droplet = DropletKit::Droplet.new(
          name: options[:name],
          region: options[:region] || 'nyc1',
          image: options[:image],
          size: 's-2vcpu-4gb'
      )
      @client.droplets.create(droplet)
    end

    def delete_droplet(options)
      @client.droplets.delete(id: options[:droplet_id])
    end

    def get_droplet(id)
      @client.droplets.find(id: id)
    end

    def get_snapshot(id)
      @client.snapshots.find(id: id)
    end

    def get_client
      @client
    end
  end
end