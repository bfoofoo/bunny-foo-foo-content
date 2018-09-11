class FormsiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :droplet_id, :droplet_ip, :zone_id, :created_at, :updated_at, :repo_url, :ad_client, :ad_sidebar_id, :ad_top_id, :ad_middle_id, :ad_bottom_id, :first_redirect_url, :final_redirect_url, :favicon_image, :logo_image, :is_thankyou, :background, :left_side_content, :right_side_content, :first_question_code_snippet, :head_code_snippet, :is_checkboxes, :is_phone_number, :form_box_title_text, :ads, :ad_client

  has_many :categories
  has_many :articles

  def ads
    Formsite::ConvertAdsToHashUseCase.new(object).perform
  end
end
