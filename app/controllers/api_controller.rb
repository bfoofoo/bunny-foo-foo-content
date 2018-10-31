class ApiController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionView::Rendering

  private
  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_url
    authenticate_token_from_url || render_unauthorized
  end

  def authenticate_token
    begin
      authenticate_with_http_token do |token, options|
        ApiClient.find_by_token(token).present?
      end
    rescue => e
      puts e
    end
  end

  def authenticate_token_from_url
    return false if params["token"].blank?
    return ApiClient.find_by_token(params["token"]).present?
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: {error: 'Bad credentials'}, status: :unauthorized
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/, '')
  end

  def paginate_items(items)
    if items.is_a?(Array)
      Kaminari.paginate_array(items).page(params[:page]).per(params[:per])
    else
      query = items.page(params[:page]).per(params[:per])
      {
        collection: query,
        total_count: query.total_count,
        total_pages: query.total_pages,
        current_page: query.current_page
      }
    end
  end
end
