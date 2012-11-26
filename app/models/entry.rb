class Entry < ActiveRecord::Base
  FEED_URL = "http://g5-hub.herokuapp.com/"
  PREFIXES = %w(g5-chd g5-ch)
  REPOS = %w(git@github.com:g5search/g5-client-hub-deployer.git git@github.com:g5search/g5-client-hub.git)

  has_many :remote_apps

  accepts_nested_attributes_for :remote_apps

  validates :bookmark, uniqueness: true

  class << self
    def feed(file_or_url=FEED_URL)
      G5HentryConsumer.parse(file_or_url)
    end

    def async_consume_feed
      Resque.enqueue(EntryConsumer)
    end

    def consume_feed(file_or_url=FEED_URL)
      feed(file_or_url).entries.each do |hentry|
        find_or_create_from_hentry(hentry)
      end
    end

    def find_or_create_from_hentry(hentry)
      find_or_create_by_bookmark(hentry.bookmark) do |entry|
        entry.name         = hentry.name.first
        entry.summary      = hentry.summary.first
        entry.content      = hentry.content
        entry.published_at = hentry.published_at.first
        entry.remote_apps_attributes = [
          { name: app_name(hentry, PREFIXES[0]),
            uid: app_uid(hentry, PREFIXES[0]),
            git_repo: REPOS[0],
            client_uid: hentry.content.first.try(:uid) },
          { name: app_name(hentry, PREFIXES[1]),
            uid: app_uid(hentry, PREFIXES[1]),
            git_repo: REPOS[1],
            client_uid: hentry.content.first.try(:uid) }
        ]
      end
    end

    def app_name(hentry, prefix)
     "#{prefix}-#{hentry.name.first.parameterize}"[0,30]
    end

    def app_uid(hentry, prefix)
      "http://#{app_name(hentry, prefix)}.herokuapp.com"
    end
  end # class << self
end
