module Colossus
  class Client
    attr_accessor :request

    def initialize(api_key)
      @request = Request.new(api_key)
    end

    def create_contact(params)
      response = @request.post("leadimport.php", create_params(params))
      Response.new(response).parse
    end
    
    private

    def create_params(data)
      params = {
        'email' => data[:email],
        'fname' => data[:first_name],
        'lname' => data[:last_name],
        'list_id' => data[:list_id],
        'apikey' => data[:api_key],
        'state' => data[:state],
        'phone' => data[:phone], 
        'ip' => data[:ip],
        "cust_field_34" => "employed",
        "cust_field_35" => "age_range",
        "cust_field_36" => "children",
        "cust_field_40" => "10k_credit_card_debt",
        "cust_field_41" => "credit_score",
        "cust_field_42" => "health_insurance",
        "cust_field_43" => "edu_level",
        "cust_field_44" => "number_children",
        "cust_field_45" => "us_citizen",
        "cust_field_46" => "bank_account",
        "cust_field_47" => "receive_coupons",
        "cust_field_48" => "horoscope",
        "cust_field_49" => "part_in_sweeps",
        "cust_field_51" => "part_gambling",
        "cust_field_52" => "hearing_loss/hearing_aid",
      }
      params
    end
  end
end
