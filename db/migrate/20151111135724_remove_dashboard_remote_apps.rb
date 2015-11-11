class RemoveDashboardRemoteApps < ActiveRecord::Migration
  def change
    RemoteApp.where(kind: 'client-dashboard').destroy_all
  end
end
