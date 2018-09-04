class ApplicationController < ActionController::Base
  def authenticate_url
    authenticate_token_from_url || render_unauthorized
  end

  def authenticate_token_from_url
    return false if params["token"].blank?
    return ApiClient.find_by_token(params["token"]).present?
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    flash[:error] = "Invalid Token"
    redirect_to :back
  end
end
