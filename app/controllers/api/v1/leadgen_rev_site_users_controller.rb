class Api::V1::LeadgenRevSiteUsersController < ApiController
  before_action :set_user, only: [:enable_tracking]

  def enable_tracking
    result = @leadgen_rev_site_user.update(is_tracking_enabled: true)
    render json: { success: result }
  end

  private

  def set_user
    @leadgen_rev_site_user = LeadgenRevSiteUser.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }
  end
end