# G5 Configurator

Deployment instructions are created manually by G5 and automagically from Client Feed.

* Receives Webhook from Client Feed Publisher
* Consumes Client Feed
* Creates Apps
* Creates Instructions
* Publishes Instruction Feed

## Setup

1. Install all gem dependencies.
```bash
$ bundle
```

1. Set up your database.
[rails-default-database](https://github.com/tpope/rails-default-database)
automatically uses sensible defaults for the primary ActiveRecord database.
```bash
$ rake db:setup
```

### Optional: Set Custom G5 Hub Entries URL
1. Set environment variable `G5_HUB_ENTRIES_URL`.
Defaults are set in `config/initializers/env.rb`.

### Optional: Autoscale Resque Workers on Heroku
1. Set environment variables `HEROKU_APP_NAME` and `HEROKU_API_KEY`.
Defaults are set in `config/initializers/env.rb`.

### Optional: Set the App Namespace
Used to determine the top-level namespace for your infrastructure (e.g. the `g5` in `g5-ch-ab123-my-apartments`).  If you plan on building a parallel infrastructure with a separate prefix for its deployed applications, you should set this.

1. Set environment variable `APP_NAMESPACE`.
Defaults are set in `config/initializers/env.rb`.

## Authors

* Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
* Bookis Smuin / [@bookis](https://github.com/bookis)
* Michael Mitchell / [@variousred](https://github.com/variousred)
* Chris Stringer / [@jcstringer](https://github.com/jcstringer)


## Contributing

1. Get it running
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write your code and **specs**
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5-configurator/issues).


## Specs

Run once.
```bash
$ rspec spec
```

Keep then running.
```bash
$ guard
```

Coverage.
```bash
$ rspec spec
$ open coverage/index.html
```
