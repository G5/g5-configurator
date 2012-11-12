class Entry < ActiveRecord::Base
  FEED_URL = "http://g5-hub.herokuapp.com/"
  PREFIXES = %w(g5-chd g5-ch)
  REPOS = %w(git@github.com:g5search/g5-client-hub-deployer.git git@github.com:g5search/g5-client-hub.git)

  has_many :remote_apps

  accepts_nested_attributes_for :remote_apps

  validates :bookmark, uniqueness: true

  class << self
    def feed
      HentryConsumer.parse(FEED_URL)
    end

    def consume_feed
      feed.entries.each do |hentry|
        find_or_create_from_hentry(hentry)
      end
    end

    def find_or_create_from_hentry(hentry)
      find_or_create_by_bookmark(hentry.bookmark) do |entry|
        entry.name         = hentry.name
        entry.summary      = hentry.summary
        entry.content      = hentry.content
        entry.published_at = hentry.published_at
        entry.remote_apps_attributes = [
          { name: "#{PREFIXES[0]}-#{hentry.name.parameterize}",
            git_repo: REPOS[0] },
          {name: "#{PREFIXES[1]}-#{hentry.name.parameterize}",
            git_repo: REPOS[0] }
        ]
      end
    end
  end # class << self
end
