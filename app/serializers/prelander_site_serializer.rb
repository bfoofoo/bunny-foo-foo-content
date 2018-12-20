class LeadgenRevSiteSerializer < ActiveModel::Serializer
    attributes :id, :name, :shortname, :favicon_image, :logo_image, :background, :created_at, :updated_at, :content, :options
  
    def content
      %i(right_side_content head_code_snippet).each_with_object({}) do |attr, memo|
        memo[attr] = object.send(attr)
      end
    end
  
    def options
      %i(
         droplet_id first_redirect_url final_redirect_url 
        ).each_with_object({}) do |attr, memo|
        memo[attr] = object.send(attr)
      end
    end
  end
  