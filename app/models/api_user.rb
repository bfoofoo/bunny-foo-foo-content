class ApiUser < ApplicationRecord
  include Swagger::Blocks
  include Esp::LinkableMethods

  ESP_MAPPING_TYPES = {
    aweber: :api_client_aweber_lists,
    adopia: :api_client_adopia_lists,
    elite: :api_client_elite_groups,
    ongage: :api_client_ongage_lists
  }.freeze

  belongs_to :api_client
  has_many :esp_rules, through: :api_client, class_name: 'EspRules::ApiClient'
  has_many :esp_rules_lists, through: :esp_rules
  has_many :exported_leads, as: :linkable

  validates :email, :first_name, :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  alias_attribute :name, :first_name

  scope :verified, -> { where("is_verified = ?", true) }
  ESP_MAPPING_TYPES.each do |provider, klass|
    scope :"with_#{provider}_mappings", -> { joins(klass).includes(klass) }
  end

  scope :by_email_domain, ->(domain) { where('api_users.email ~* ?', '@' + domain + '\.\w+$') }

  swagger_schema :ApiUser do
    key :required, [:email, :first_name, :last_name]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :email do
      key :type, :string
    end
    property :first_name do
      key :type, :string
    end
    property :last_name do
      key :type, :string
    end
    property :website do
      key :type, :string
    end

    property :ip do
      key :type, :string
    end

    property :captured do
      key :type, :datetime
    end

    property :lead_id do
      key :type, :string
    end

    property :zip do
      key :type, :string
    end

    property :state do
      key :type, :string
    end

    property :phone1 do
      key :type, :string
    end

    property :job do
      key :type, :string
    end

    property :s1 do
      key :type, :string
    end
    property :s2 do
      key :type, :string
    end
    property :s3 do
      key :type, :string
    end
    property :s4 do
      key :type, :string
    end
    property :s5 do
      key :type, :string
    end
    property :is_verified do
      key :type, :boolean
    end
    property :is_useragent_valid do
      key :type, :boolean
    end
    property :is_impressionwise_test_success do
      key :type, :boolean
    end
    property :is_duplicate do
      key :type, :boolean
    end
  end

  swagger_schema :ApiUserInput do
    allOf do
      schema do
        key :required, [:email, :first_name, :last_name]
        property :email do
          key :type, :string
        end
        property :first_name do
          key :type, :string
        end
        property :last_name do
          key :type, :string
        end
        property :website do
          key :type, :string
        end

        property :ip do
          key :type, :string
        end

        property :captured do
          key :format, 'date-time'
          key :type, :string
        end

        property :lead_id do
          key :type, :string
        end

        property :zip do
          key :type, :string
        end

        property :state do
          key :type, :string
        end

        property :phone1 do
          key :type, :string
        end

        property :job do
          key :type, :string
        end

        property :s1 do
          key :type, :string
        end
        property :s2 do
          key :type, :string
        end
        property :s3 do
          key :type, :string
        end
        property :s4 do
          key :type, :string
        end
        property :s5 do
          key :type, :string
        end
      end
    end
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end
