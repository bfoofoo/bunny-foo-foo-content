class Api::V1::MailgunCallbacksController < ApiController
  before_action :set_recipient, only: [:click, :open]
  # TODO maybe verify all requests

  def click
    if @recipient&.autoresponse_message_id == message_id
      @recipient.touch(:clicked_at)
      @recipient.autorespond(followup: true, event: :click)
      render json: { message: 'success' }
    elsif @recipient
      head :no_content
    else
      render json: { message: 'Recipient not found' }, status: :not_found
    end
  end

  def open
    if @recipient&.autoresponse_message_id == message_id
      @recipient.touch(:opened_at)
      @recipient.autorespond(followup: true, event: :open)
      render json: { message: 'success' }
    elsif @recipient
      head :no_content
    else
      render json: { message: 'Recipient not found' }, status: :not_found
    end
  end

  private

  def set_recipient
    @recipient = ExportedLead
      .joins_linkable
      .where(list_type: 'MailgunList')
      .where('users.email = :email OR api_users.email = :email', email:  params[:recipient])
      .order(created_at: :desc)
      .autoresponded
      .first
  end

  def message_id
    params.dig('message', 'headers', 'message-id')
  end
end
