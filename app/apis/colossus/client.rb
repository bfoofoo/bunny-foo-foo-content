module Colossus
  class Client
    attr_accessor :request

    def initialize(api_key)
      @request = Request.new(api_key)
    end

    def create_contact(params)
      response = @request.post('leadimport.php', create_params(params))
      Response.new(response).parse
    end
    
    private

    def create_params(data)
      {
        'email' => data[:email],
        'fname' => data[:first_name],
        'lname' => data[:last_name],
        'list_id' => data[:list_id],
        'apikey' => data[:api_key],
        'state' => data[:state],
        'phone' => data[:phone], 
        'ip' => data[:ip],
        'cust_field_34' => data[:employed],
        'cust_field_35' => data[:age_range],
        'cust_field_36' => data[:children],
        'cust_field_40' => data[:ten_k_credit_card_debt],
        'cust_field_41' => data[:credit_score],
        'cust_field_42' => data[:health_insurance],
        'cust_field_43' => data[:edu_level],
        'cust_field_44' => data[:number_children],
        'cust_field_45' => data[:us_citizen],
        'cust_field_46' => data[:bank_account],
        'cust_field_47' => data[:receive_coupons],
        'cust_field_48' => data[:horoscope],
        'cust_field_49' => data[:part_in_sweeps],
        'cust_field_51' => data[:part_gambling],
        'cust_field_52' => data[:hearing_loss_hearing_aid]
      }.compact
    end
  end
end
