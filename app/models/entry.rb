class Entry < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :bookmark, uniqueness: true
  has_many :remote_apps
  after_create :spin_up_app
  
  HUB_URL = "http://g5-hub.herokuapp.com/"
  
  def self.consume_feed
    entries = feed.entries.map do |hentry|
      find_or_initialize_from_entry(hentry)
    end
    entries.each(&:save)
  end
  
  def self.find_or_initialize_from_entry(hentry)
    self.find_or_initialize_by_bookmark(hentry.bookmark) do |entry|
      entry.name         = hentry.name
      entry.summary      = hentry.summary
      entry.content      = hentry.content
      entry.published_at = hentry.published_at
    end
  end
  
  private
  
  def spin_up_app
    %w(ClientHub ClientDeployer).each do |app_type|
      app = remote_apps.build(name: self.name.parameterize, app_type: app_type)
      app.save
      app.spin_up
    end
  end
  
  def self.feed
    HentryConsumer.parse(self::HUB_URL)
  end
  
end
