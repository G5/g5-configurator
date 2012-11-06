class Entry < ActiveRecord::Base
  validates :bookmark, uniqueness: true
  has_one :remote_app
  accepts_nested_attributes_for :remote_app

  HUB_URL = "http://g5-hub.herokuapp.com/"


  def self.consume_feed
    entries = feed.entries.map do |hentry|
      find_or_create_from_entry(hentry)
    end
  end

  def self.find_or_create_from_entry(hentry)
    a=self.find_or_create_by_bookmark(hentry.bookmark) do |entry|
      entry.name         = hentry.name
      entry.summary      = hentry.summary
      entry.content      = hentry.content
      entry.published_at = hentry.published_at
      entry.remote_app_attributes = {name: hentry.name.parameterize}
    end
  end

  def self.feed
    HentryConsumer.parse(self::HUB_URL)
  end

end
