class ApplicationController < ActionController::Base
  before_action :save_user_email_to_session

  def test
    restuls = Esp::BatchSendToNetatlanticWorker.new().test
    send_data restuls, filename: "filename.csv"
  end

  def save_user_email_to_session
    if session[:user_email].blank? && !current_admin_user.blank? && session[:user_email] != current_admin_user&.email
      session[:user_email] ||= current_admin_user&.email
    end
  end

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
