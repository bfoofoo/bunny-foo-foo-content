require 'cloudflare'
module Deployer
  class CloudflareService
    # BASE_URL = "http://api.cloudflare.com"

    def initialize
      @client = Cloudflare.connect(key: ENV['CLOUDFLARE_KEY'], email: ENV['CLOUDFLARE_EMAIL'])
    end

    def create_zone(name)
      @client.zones.post({name: name}.to_json, content_type: 'application/json')
    end

    def add_dns_to_zone(options)
      zone = get_zone(options[:id])
      zone.dns_records.post({
        "type": 'A',
        "name": options[:name],
        "content": options[:ip],
      }.to_json,
      content_type: 'application/json')
    end

    def delete_zone(options)
      zone = get_zone(options[:zone_id])
      zone.delete
    end

    def get_zone(id)
      @client.zones.find_by_id(id)
    end

    def get_client
      @client
    end
  end
end

