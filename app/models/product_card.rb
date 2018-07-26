class ProductCard < ApplicationRecord
  belongs_to :website, optional: true
  mount_uploader :image, CommonUploader
end
