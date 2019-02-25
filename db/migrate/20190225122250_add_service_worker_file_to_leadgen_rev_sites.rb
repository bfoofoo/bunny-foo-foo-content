class AddServiceWorkerFileToLeadgenRevSites < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :service_worker_file, :text
  end
end
