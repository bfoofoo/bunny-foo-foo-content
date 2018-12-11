require 'ipaddr'
module GeocoderInteractor
  class GetStateByIP
    include Interactor

    delegate :ip, :state, to: :context

    def call
      context.state = IpLocation.find_by('ip_from <= :ip AND ip_to >= :ip', ip: string_to_num(ip))&.region_name
    end

    def string_to_num(ip)
      IPAddr.new(ip).to_i
    rescue
      context.state = nil
      context.fail!
    end
  end
end