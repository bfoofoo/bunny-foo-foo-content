class ExportedLead < ApplicationRecord
  belongs_to :list, polymorphic: true
  belongs_to :linkable, polymorphic: true
end
