class Callbacks::Aweber::AccountsController < ApplicationController

  def auth_account
    response = AweberInteractor::AddAccountOrganizer.call({params: params, session:session})
    flash[:error] = response.message if !response.success?
    flash[:notice] = response.message if response.success? && !response.message.blank?
    redirect_to admin_aweber_accounts_path
  end
end
