class Api::V1::MailgunCallbacksController < ApiController
  before_action :set_recipient, only: [:click, :open]
  # TODO maybe verify all requests

  def click
    if message_id && @recipient
      @recipient.autorespond(message_id, event: :click)
      render json: { message: 'success' }
    else
      head :no_content
    end
  end

  def open
    if message_id && @recipient
      @recipient.autorespond(message_id, event: :open)
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
      .by_message(message_id)
      .where(list_type: 'MailgunList')
      .first
  end

  def message_id
    params.dig('event-data', 'message', 'headers', 'message-id')
  end
end
