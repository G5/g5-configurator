desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  puts "Updating feed..."
  Entry.consume_feed
  puts "done."
end

desc "Deploy to Heroku. Pass APP=appname to deploy to a different app"
task :deploy do
  require 'heroku'
  require 'heroku/command'
  user, pass = File.read(File.expand_path("~/.heroku/credentials")).split("\n")
  heroku = Heroku::Client.new(user, pass)

  cmd = Heroku::Command::BaseWithApp.new([])
  remotes = cmd.git_remotes(File.dirname(__FILE__) + "/../..")

  remote, app = remotes.detect {|key, value| value == (ENV['APP'] || cmd.app)}

  if remote.nil?
    raise "Could not find a git remote for the '#{ENV['APP']}' app"
  end

  `git push #{remote} master`

  heroku.rake(app, "db:migrate")
  heroku.restart(app)
end