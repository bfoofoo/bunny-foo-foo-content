class ConvertSentPendingLeadsToExportedLeads < ActiveRecord::Migration[5.0]
  def change
    # Adopia First round
    PendingLead.where.not(sent_at: nil).where(sent_to_adopia: false, sent_to_netatlantic: false).order(created_at: :desc).find_in_batches do |batch|
      exported_leads = batch.map do |pl|
        {
          linkable_type: 'PendingLead',
          linkable_id: pl.id,
          list_type: 'AdopiaList',
          created_at: pl.sent_at
        }
      end
      ExportedLead.import(exported_leads)
    end
    # Netatlantic
    PendingLead.where(sent_to_netatlantic: true).order(created_at: :desc).find_in_batches do |batch|
      exported_leads = batch.map do |pl|
        {
          linkable_type: 'PendingLead',
          linkable_id: pl.id,
          list_type: 'NetatlanticList',
          created_at: pl.sent_at || 1.month.ago
        }
      end
      ExportedLead.import(exported_leads)
    end
    # Adopia Second round
    PendingLead.where(sent_to_adopia: true).order(created_at: :desc).find_in_batches do |batch|
      exported_leads = batch.map do |pl|
        {
          linkable_type: 'PendingLead',
          linkable_id: pl.id,
          list_type: 'AdopiaList',
          created_at: pl.sent_at || 1.month.ago
        }
      end
      ExportedLead.import(exported_leads)
    end
  end
end
