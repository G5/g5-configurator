class EntryConsumer
  extend HerokuResqueAutoscaler
  @queue = :consumer

  def self.perform
    Entry.consume_feed
  end
end
