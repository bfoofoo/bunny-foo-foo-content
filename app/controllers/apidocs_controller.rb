class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'BFF Admin api'
    end
    tag do
      key :name, 'api_user'
      key :description, 'Api Users operations'
    end
    key :host, ''
    key :schemes, ['http']
    key :basePath, '/api/v1/'
    key :consumes, ['application/json']
    key :produces, ['application/json']
    security_definition :api_key do
      key :type, :apiKey
      key :name, :Authorization
      key :in, :header
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
      Api::V1::ApiUsersController,
      ApiUser,
      ErrorModel,
      self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end