class AddOneSignalFileToLeadgenRevSite < ActiveRecord::Migration[5.0]
  def change
    add_column :leadgen_rev_sites, :one_signal_sdk_worker_file, :text
  end
end
