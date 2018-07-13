class ProductCard < ApplicationRecord
  mount_uploader :image, CommonUploader
end
