class SmsSubscriber < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  belongs_to :source, polymorphic: true
  belongs_to :cep_rule, optional: true

  store_accessor :params, :group_id
end
