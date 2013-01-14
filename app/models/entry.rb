class Entry < ActiveRecord::Base
  FEED_URL = "http://g5-hub.herokuapp.com/"

  has_many :remote_apps

  accepts_nested_attributes_for :remote_apps

  validates :uid, uniqueness: true
  scope :recently_modified, order("updated_at DESC")

  class << self
    def feed(file_or_url=FEED_URL)
      G5HentryConsumer.parse(file_or_url, last_modified_at:  last_modified_at)
    end

    def last_modified_at
      maximum(:created_at)
    end

    def async_consume_feed
      Resque.enqueue(EntryConsumer)
    end

    def consume_feed(file_or_url=FEED_URL)
      feed(file_or_url).entries.each do |hentry|
        find_or_create_from_hentry(hentry)
      end
    rescue OpenURI::HTTPError, "304 Not Modified"
      true
    end

    def find_or_create_from_hentry(hentry)
      find_or_create_by_uid(hentry.bookmark) do |entry|
        client_uid = hentry.content.first.try(:uid)
        client_name = hentry.content.first.try(:name).try(:first)
        entry.remote_apps_attributes = [
          { kind: RemoteApp::CLIENT_HUB,
            client_uid: client_uid,
            client_name: client_name },
          { kind: RemoteApp::CLIENT_HUB_DEPLOYER,
            client_uid: client_uid,
            client_name: client_name }
        ]
      end
    end
  end # class << self
end
