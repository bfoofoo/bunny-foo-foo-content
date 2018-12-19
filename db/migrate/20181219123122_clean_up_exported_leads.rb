class CleanUpExportedLeads < ActiveRecord::Migration[5.0]
  def change
    # remove exported leads with empty linkable
    # also need investigate, why they're empty
    ExportedLead.where(linkable: nil).delete_all

    # remove leftover leads and EspList with AweberList, MaropostList, OngageList
    EspList.where(type: ['AweberList', 'MaropostList', 'OngageList']).delete_all
    ExportedLead.where(list_type: ['AweberList', 'MaropostList']).delete_all
    
    # change list_type from EspList to real list type
    ExportedLead.where(list_type: 'EspList').map do |el|
      el.list_type = el.list.type
      el.save!
    end
  end
end
