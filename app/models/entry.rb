class Entry < ActiveRecord::Base
  has_many :remote_apps
  accepts_nested_attributes_for :remote_apps

  validates :uid, uniqueness: true
  scope :recently_modified, -> { order("updated_at DESC") }

  class << self
    def feed_url
      G5HubService.feed_url
    end

    def feed
      Rails.logger.info("Grabbing and parsing the feed")
      Microformats2.parse(feed_url)
    end

    def consume_feed
      begin
        Rails.logger.info("begin consume_feed from #{feed_url}")
        feed.entries.map do |hentry|
          Rails.logger.info("finding or creating from hentry: #{hentry}, 
                            Entry count: #{Entry.count}")
          Rails.logger.info("the uid is: #{hentry.uid.to_s}")
          find_or_create_from_hentry(hentry)
          Rails.logger.info("done finding or creating from hentry. 
                            Entry count: #{Entry.count}")
        end
      rescue OpenURI::HTTPError => e
        Rails.logger.info("rescuing from: #{e}")
        raise e unless /304 Not Modified/ =~ e.message
        []
      end
    end

    def async_consume_feed
      Resque.enqueue(EntryConsumer)
    end

    def find_or_create_from_hentry(hentry)
      Rails.logger.info("begin find_or_create_from_hentry, find_or_create_by: #{hentry.uid.to_s}")
      find_or_create_by(uid: hentry.uid.to_s) do |entry|
        Rails.logger.info("processing entry: #{entry}")
        Rails.logger.info("client(hentry): #{client(hentry)}")
        client = client(hentry)
        client_uid = client.uid.to_s
        client_name = client.name.to_s
        organization = client.g5_organization.to_s

        client_app_kinds = AppDefinition::CLIENT_APP_DEFINITIONS.map(&:kind)
        Rails.logger.info("client app kinds: #{client_app_kinds}")
        entry.remote_apps_attributes = client_app_kinds.map do |kind|
          { kind: kind,
            client_uid: client_uid,
            client_name: client_name,
            organization: organization }
        end
        Rails.logger.info("Entry setup complete. Valid?: #{entry.valid?}")
      end
    end

    def client(hentry)
      Microformats2.parse(hentry.content.to_s).card
    end
  end # class << self
end
