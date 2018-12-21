class DigitalOceanAccount < Account
  # see DigitalOcean API at 'v2/sizes'
  SIZES = {
    "s-1vcpu-1gb"=>5.0,
    "s-1vcpu-2gb"=>10.0,
    "s-1vcpu-3gb"=>15.0,
    "s-2vcpu-2gb"=>15.0,
    "s-3vcpu-1gb"=>15.0,
    "s-2vcpu-4gb"=>20.0,
    "s-4vcpu-8gb"=>40.0,
  }.freeze

  store_accessor :params, :leadrev_image_id, :formsite_image_id, :website_image_id

  validates :api_key, presence: true
end