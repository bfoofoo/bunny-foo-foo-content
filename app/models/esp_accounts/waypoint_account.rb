class WaypointAccount < EspAccount
  has_many :waypoint_lists, dependent: :destroy, foreign_key: :account_id

  alias_attribute :lists, :waypoint_lists

  validates :api_key, :username, presence: true, uniqueness: true

  def display_name
    username
  end
end