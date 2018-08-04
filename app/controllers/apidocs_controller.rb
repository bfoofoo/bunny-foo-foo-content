class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'BFF Admin api'
    end
    tag do
      key :name, 'article'
      key :description, 'Articles operations'
    end
    key :host, 'https://admin.bunny-foo-foo.app'
    key :basePath, '/api/v1/'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
      Api::V1::ArticlesController,
      Article,
      ErrorModel,
      self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end