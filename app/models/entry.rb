class Entry < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :bookmark, uniqueness: true
  has_one :remote_app, dependent: :destroy
  after_create :spin_up_app
  
  HUB_URL = "http://g5-hub.herokuapp.com/"
  
  def self.consume_feed
    entries = feed.entries.map do |hentry|
      find_or_initialize_from_entry(hentry)
    end
    puts "******"
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
    app = build_remote_app(name: self.name.parameterize)
    app.save
    app.spin_up
  end
  
  def self.feed
    HentryConsumer.parse(self::HUB_URL)
  end
  
end
