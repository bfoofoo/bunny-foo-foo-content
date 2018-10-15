module Adopia
  class Client
    def initialize(api_key)
      @request = Request.new(api_key)
    end

    def pull_user_lists
      request = @request.get(self_path)
      data = Response.new(request).parse
      Resources::Lists.new(data).collection
    end

    #  +params+ must contain elements:
    #    :contact_email
    #    :is_double_opt_in => 0 or 1
    #    :contact_name OR :contact_first_name / :contact_last_name
    def add_list_contact(list_id, params = {})
      contact_params = Resources::Contacts.build(params)
      request = @request.get(self_path, params.merge(list_id: list_id, **contact_params))
      response = Response.new(request).parse
      if response[:status] == 'error'
        raise Errors::UnprocessableEntityError.new, response[:message]
      end
    end

    private

    # get camelcase version of (caller) method name
    def self_path
      caller_locations(1,1)[0].label.to_s.camelize(:lower)
    end
  end
end
