class LeadgenRevSiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :shortname, :favicon_image, :logo_image, :background, :background_opacity, :background_color, :created_at, :updated_at, :content, :options

  has_many :categories
  has_many :advertisements
  has_many :trackers
  has_many :pixel_code_snippets
  has_many :leadgen_rev_site_popups
  has_many :widgets
  has_many :leadgen_entries

  def content
    %i(first_question_code_snippet left_side_content right_side_content head_code_snippet).each_with_object({}) do |attr, memo|
      memo[attr] = object.send(attr)
    end
  end

  def options
    %i(
       is_thankyou is_phone_number is_checkboxes droplet_id ad_client first_redirect_url
       final_redirect_url s1_description s2_description s3_description s4_description s5_description
       form_box_title_text affiliate_description show_popup popup_delay popup_iframe_urls
       leadgen_entry form_background_color form_text_color
      ).each_with_object({}) do |attr, memo|
      memo[attr] = object.send(attr)
    end
  end
end
