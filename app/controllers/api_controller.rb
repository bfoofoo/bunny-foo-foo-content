class ApiController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods

  private
  def authenticate
    authenticate_token || render_unauthorized
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

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: {error: 'Bad credentials'}, status: :unauthorized
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/, '')
  end
end
