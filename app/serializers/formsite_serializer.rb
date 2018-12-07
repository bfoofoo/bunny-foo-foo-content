class FormsiteSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :updated_at, :ad_client, :ad_sidebar_id, :ad_top_id, :ad_middle_id, :ad_bottom_id, :fraud_user_redirect_url, :first_redirect_url, :final_redirect_url, :favicon_image, :logo_image, :is_thankyou, :background, :left_side_content, :right_side_content, :first_question_code_snippet, :head_code_snippet, :is_checkboxes, :is_phone_number, :form_box_title_text, :ads, :ad_client

  has_many :categories
  has_many :articles

  def ads
    Formsite::ConvertAdsToHashUseCase.new(object).perform
  end
end
