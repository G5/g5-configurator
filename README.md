# G5 Configurator

* Consumes g5-hub's feed
* Publishes feed of instructions to targets (g5-client-app-creator, g5-ch-*, g5-chd-*)
* Pings g5-client-app-creator when feed is updated via webhook


## Setup

1. Install all gem dependencies.
```bash
bundle
```

1. Set up your database. 
[rails-default-database](https://github.com/tpope/rails-default-database) 
automatically uses sensible defaults for the primary ActiveRecord database.
```bash
rake db:setup
```

1. Export environment variables.
```bash
export CLIENT_APP_CREATOR_WEBHOOK_URL=http://g5-client-app-ceator.dev/consume_feed
export HEROKU_APP_NAME=g5-configurator # only needed on production
export HEROKU_API_KEY=heroku_api_key # only needed on production
```


## Authors

* Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
* Bookis Smuin / [@bookis](https://github.com/bookis)


## Contributing

1. Fork it
1. Get it running
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write your code and **specs**
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5-configurator/issues).


## Specs

```bash
guard
```

## Coverage

```bash
rspec spec
open coverage/index.html
```
