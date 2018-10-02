require 'cloudflare'
require 'rest-client'
module Deployer
  class CloudflareService
    # BASE_URL = "http://api.cloudflare.com"

    def initialize
      # @client = Cloudflare.connect(key: ENV['CLOUDFLARE_KEY'], email: ENV['CLOUDFLARE_EMAIL'])
      @client = Cloudflare.connect(key: 'a1510d55f0c8e5318d102eb84c6cd1a3198e5', email: 'peter@bunnyfoofoo.net')
    end

    def create_zone(name)
      @client.zones.post({name: name}.to_json, content_type: 'application/json')
    end

    def add_dns_to_zone(options)
      zone = get_zone(options[:id])
      dns_conf = {
          "type": options[:type],
          "name": options[:name],
          "content": options[:ip]
      }
      options[:proxied] && dns_conf["proxied"] = options[:proxied]
      options[:ttl] && dns_conf["ttl"] = options[:ttl]
      options[:priority] && dns_conf["priority"] = options[:priority]

      zone.dns_records.post(dns_conf.to_json, content_type: 'application/json')
    end

    def change_ssl_settings(options)
      RestClient.patch("https://api.cloudflare.com/client/v4/zones/#{options[:id]}/settings/ssl", {'value' => 'strict'}.to_json, {
          "X-Auth-Key": "a1510d55f0c8e5318d102eb84c6cd1a3198e5",
          "X-Auth-Email": "peter@bunnyfoofoo.net",
          content_type: :json
      })
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

