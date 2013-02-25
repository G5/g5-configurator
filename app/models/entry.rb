class Entry < ActiveRecord::Base
  has_many :remote_apps
  accepts_nested_attributes_for :remote_apps

  validates :uid, uniqueness: true
  scope :recently_modified, order("updated_at DESC")

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
    rescue OpenURI::HTTPError, "304 Not Modified"
      []
    end

    def async_consume_feed
      Resque.enqueue(EntryConsumer)
    end

    def find_or_create_from_hentry(hentry)
      find_or_create_by_uid(hentry.uid.to_s) do |entry|
        hcard = Microformats2.parse(hentry.content.to_s).card
        client_uid = hcard.uid.to_s
        client_name = hcard.name.to_s
        entry.remote_apps_attributes = [
          { kind: RemoteApp::CLIENT_HUB,
            client_uid: client_uid,
            client_name: client_name },
          { kind: RemoteApp::CLIENT_HUB_DEPLOYER,
            client_uid: client_uid,
            client_name: client_name },
          { kind: RemoteApp::CLIENT_LEADS_SERVICE,
            client_uid: client_uid,
            client_name: client_name }
        ]
      end
    end

    def client(hentry)
      Microformats2.parse(hentry.content.to_s).card
    end
  end # class << self
end
