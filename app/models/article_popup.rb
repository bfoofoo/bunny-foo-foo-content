class ArticlePopup < ApplicationRecord
  belongs_to :article
  belongs_to :leadgen_rev_site
end
