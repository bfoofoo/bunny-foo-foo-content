class ProductCard < ApplicationRecord
  belongs_to :website, optional: true
  belongs_to :leadgen_rev_site, optional: true
  mount_uploader :image, CommonUploader
end
