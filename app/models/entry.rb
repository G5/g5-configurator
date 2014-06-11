class Entry < ActiveRecord::Base
  has_many :remote_apps
  accepts_nested_attributes_for :remote_apps

  validates :uid, uniqueness: true
  scope :recently_modified, -> { order("updated_at DESC") }

  class << self
    def feed_url
      ENV["G5_HUB_ENTRIES_URL"]
    end

    def feed
      Microformats2.parse(feed_url)
    end

    def consume_feed
      feed.entries.map do |hentry|
        find_or_create_from_hentry(hentry)
      end
    rescue OpenURI::HTTPError => e
      raise e unless /304 Not Modified/ =~ e.message
      []
    end

    def async_consume_feed
      Resque.enqueue(EntryConsumer)
    end

    def find_or_create_from_hentry(hentry)
      find_or_create_by(uid: hentry.uid.to_s) do |entry|
        client = client(hentry)
        client_uid = client.uid.to_s
        client_name = client.name.to_s

        client_app_kinds = AppDefinition::CLIENT_APP_DEFINITIONS.map(&:kind)
        entry.remote_apps_attributes = client_app_kinds.map do |kind|
          { kind: kind,
            client_uid: client_uid,
            client_name: client_name }
        end
      end
    end

    def client(hentry)
      Microformats2.parse(hentry.content.to_s).card
    end
  end # class << self
end
