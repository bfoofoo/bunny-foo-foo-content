class SmsSubscriber < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  belongs_to :source, polymorphic: true
end
