class ApiClientMapping < EmailMarketerMapping
  default_scope -> { where(source_type: 'ApiClient') }

  def should_send_now?(datetime)
    datetime.beginning_of_hour == Time.zone.now.beginning_of_hour - delay_in_hours.hours
  end
end
