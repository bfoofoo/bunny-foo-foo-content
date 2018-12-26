class PrelanderSite < ApplicationRecord
    acts_as_paranoid

    has_many :questions, dependent: :destroy
    has_many :prelander_site_users, dependent: :restrict_with_error
    has_many :users, through: :prelander_site_users do
        def verified
            where("prelander_site_users.is_verified = ?", true)
        end

        def unverified
            where("prelander_site_users.is_verified = ?", false)
        end
    end

    belongs_to :digital_ocean_account, foreign_key: :account_id

    accepts_nested_attributes_for :questions, allow_destroy: true

    validates :name, presence: true, uniqueness: true

    after_save :mark_last_question

    mount_uploader :favicon_image, CommonUploader
    mount_uploader :logo_image, CommonUploader
    mount_uploader :background, CommonUploader

    def mark_last_question
        return if questions.empty?
        questions.update_all(is_last: false)
        questions.last.mark_as_last!
    end

    def builder_config
        {
          id: self.id,
          name: self.name,
          description: self.description || '',
          favicon_image: self.favicon_image.url || '',
          logo_image: self.logo_image.url || '',
          website_id: self.id,
          droplet_ip: self.droplet_ip,
          droplet_id: self.droplet_id,
          zone_id: self.zone_id,
          repo_url: self.repo_url,
          type: 'prelander_site',
          size_slug: self.size_slug,
          account_id: self.account_id
        }
    end

end
