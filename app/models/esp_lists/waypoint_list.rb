class WaypointList < EspList
  belongs_to :waypoint_account, foreign_key: :account_id

  alias_attribute :account, :waypoint_account
end