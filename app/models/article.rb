class Article < ApplicationRecord
  belongs_to :category

  mount_uploader :cover_image, CommonUploader
end
