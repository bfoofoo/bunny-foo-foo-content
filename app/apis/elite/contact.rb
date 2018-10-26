module Elite
  class Contact < Resource

    def get_interest_groups
      response = request.post(self_path)
      parse_collection(Response.new(response).parse)
    end

    def add_contact_to_interest_group(group_id, ids)
      response = request.post(self_path, {
        'GroupToAddToId' => group_id,
        'ContactIds' => ids.map do |id|
          { 'ContactId' => id }
        end
      })
      Response.new(response).parse
    end

    # +params+ must include:
    #   'GroupsToAddToIds' => Array
    # +contacts+ Array elements must have:
    #  'EmailAddress' => String
    def create_contacts(params, contacts)
      response = request.post(self_path, {
        'GroupsToAddToIds' => params['GroupsToAddToIds'],
        'CreateContactItems' => contacts.map do |c|
          {
            'EmailAddress' => c['EmailAddress'],
            'ContactFields' => c.except('EmailAddress')
          }
        end
      })
      Response.new(response).parse
    end

    # +contacts+ Array elements must have:
    #  'EmailAddress' => String
    def update_contacts(contacts)
      response = request.post(self_path, {
        'UpdateContactItems' => contacts.map do |c|
          {
            'EmailAddress' => c['EmailAddress'],
            'ContactFields' => c.except('EmailAddress')
          }
        end
      })
      Response.new(response).parse
    end

    private

    def parse_collection(response)
      return [] if response['ContactGroups'].to_a.empty?
      response['ContactGroups'].map do |item|
        OpenStruct.new(name: item['ContactGroupName'], group_id: item['ContactGroupId'])
      end
    end
  end
end
