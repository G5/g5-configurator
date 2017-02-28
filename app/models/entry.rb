class Entry < ActiveRecord::Base
  has_many :remote_apps
  accepts_nested_attributes_for :remote_apps

  validates :uid, uniqueness: true
  scope :recently_modified, -> { order("updated_at DESC") }

  def self.create_from_updatable_client(g5_updatable_client)
    find_or_create_by(uid: g5_updatable_client.uid) do |entry|
      client_app_kinds = AppDefinition::CLIENT_APP_DEFINITIONS.map(&:kind)
      entry.remote_apps_attributes = client_app_kinds.map do |kind|
        { kind: kind,
          client_uid: g5_updatable_client.uid,
          client_name: g5_updatable_client.name,
          organization: g5_updatable_client.organization }
      end
    end
  end
end
