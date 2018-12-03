class AweberAccount < EspAccount
  has_many :aweber_lists, dependent: :destroy

  alias_attribute :lists, :aweber_lists
end
