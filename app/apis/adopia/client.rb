module Adopia
  class Client
    attr_accessor :request

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

    #  +list_ids+ - array
    #  +paras+ must contain:
    #    :is_double_opt_in => 0 or 1
    #    :contacts => array of hashes, required elements:
    #      :contact_email => string
    #
    def add_list_contacts(list_ids, params = {})
      contact_params = params[:contacts].each_with_object({}).with_index do |(value, hash), index|
        hash[index.to_s.to_sym] = value
      end
      request = @request.post(self_path, {
        list_ids: list_ids.join(','),
        contact: contact_params,
        **params.except(:contacts)
      })
      response = Response.new(request).parse
      if response[:status] == 'error'
        raise Errors::UnprocessableEntityError.new, response[:message]
      end
    end

    def delete_list_contact(list_id, email)
      request = @request.get(self_path, { list_id: list_id, contact_email: email })
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
