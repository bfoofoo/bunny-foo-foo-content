class Api::V1::MailgunCallbacksController < ApiController
  before_action :set_recipient, only: [:click, :open]
  # TODO maybe verify all requests

  def click
    if message_id && @recipient && !@recipient.clicked_at?
      @recipient.touch(:clicked_at)
      @recipient.autorespond(followup: true, event: :click)
      render json: { message: 'success' }
    else
      head :no_content
    end
  end

  def open
    if message_id && @recipient && !@recipient.opened_at?
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
      .autoresponded
      .where(list_type: 'MailgunList')
      .where('exported_leads.autoresponse_message_id = ?', message_id)
      .order(created_at: :desc)
      .first
  end

  def message_id
    params.dig('event-data', 'message', 'headers', 'message-id')
  end
end
