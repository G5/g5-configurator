class EntryConsumer
  extend HerokuResqueAutoscaler
  @queue = :consumer

  def self.perform
    puts "start consuming feed"
    Entry.consume_feed
    puts "done consuming feed"
  end
end
