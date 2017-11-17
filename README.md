# Valkyrie::Redis

A Redis metadata backend for [Valkyrie](https://github.com/samvera-labs/valkyrie)

[![CircleCI](https://circleci.com/gh/samvera-labs/valkyrie-redis.svg?style=svg)](https://circleci.com/gh/samvera-labs/valkyrie-redis)
[![Coverage Status](https://coveralls.io/repos/github/samvera-labs/valkyrie-redis/badge.svg?branch=master)](https://coveralls.io/github/samvera-labs/valkyrie-redis?branch=master)

## Requirements

### Ruby version
Ruby 2.3 or above

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'valkyrie-redis'
```

## Usage

Follow the Valkyrie README to get a development or production environment up and running. To enable Redis support,
add the following to your application's `config/initializers/valkyrie.rb`:

    Valkyrie::MetadataAdapter.register(
      Valkyrie::Persistence::Redis::MetadataAdapter.new,
      :redis
    )

You can then use `:redis` as a metadata adapter value in `config/valkyrie.yml`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/samvera-labs/valkyrie-redis/.

## License

`Valkyrie::Redis` is available under [the Apache 2.0 license](LICENSE).
