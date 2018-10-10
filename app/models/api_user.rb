class ApiUser < ApplicationRecord
  include Swagger::Blocks
  belongs_to :api_client

  has_many :aweber_list_users, class_name: 'AweberListUser', as: :linkable
  has_many :aweber_lists, through: :aweber_list_users, source: :list, source_type: 'AweberList'
  has_many :api_client_mappings, through: :api_client
  
  validates :email, :first_name, :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  alias_attribute :name, :first_name

  scope :verified, -> { where("is_verified = ?", true) }
  scope :with_aweber_mappings, -> { joins(:api_client_mappings).includes(:api_client_mappings) }

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

  def sent_to_aweber?
    aweber_list_users.exists?
  end

  def sent_to_aweber_list?(list)
    aweber_list_users.where(list: list).exists?
  end
end
