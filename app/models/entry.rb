class Entry < ActiveRecord::Base
  validates :bookmark, uniqueness: true
  has_many :remote_apps
  accepts_nested_attributes_for :remote_apps
  PREFIXES = %w(g5-chd g5-ch)
  HUB_URL = "http://g5-hub.herokuapp.com/"


  def self.consume_feed
    entries = feed.entries.map do |hentry|
      find_or_create_from_entry(hentry)
    end
  end

  def self.find_or_create_from_entry(hentry)
    self.find_or_create_by_bookmark(hentry.bookmark) do |entry|
      entry.name         = hentry.name
      entry.summary      = hentry.summary
      entry.content      = hentry.content
      entry.published_at = hentry.published_at
      entry.remote_apps_attributes = [
        {name: "g5-chd-#{hentry.name.parameterize}", git_repo: "git@github.com:g5search/g5-client-hub-deployer"},
        {name: "g5-ch-#{hentry.name.parameterize}",  git_repo: "git@github.com:g5search/g5-client-hub"}
      ]
    end
  end

  def self.feed
    HentryConsumer.parse(self::HUB_URL)
  end

end
