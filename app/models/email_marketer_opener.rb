class EmailMarketerOpener < ApplicationRecord
  belongs_to :source_list, polymorphic: true
end
