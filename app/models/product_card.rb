class ProductCard < ApplicationRecord
  belongs_to :website, optional: true
  has_many :product_cards_leadgen_rev_sites
  has_many :leadgen_rev_site, through: :product_cards_leadgen_rev_sites
  mount_uploader :image, CommonUploader
end
