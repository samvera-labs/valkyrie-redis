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

If you're working on a PR for this project, create a feature branch off of `main`. 

This repository follows the [Samvera Community Code of Conduct](https://samvera.atlassian.net/wiki/spaces/samvera/pages/405212316/Code+of+Conduct) and [language recommendations](https://github.com/samvera/maintenance/blob/master/templates/CONTRIBUTING.md#language).  Please ***do not*** create a branch called `master` for this repository or as part of your pull request; the branch will either need to be removed or renamed before it can be considered for inclusion in the code base and history of this repository.

Bug reports and pull requests are welcome on GitHub at https://github.com/samvera-labs/valkyrie-redis/.

## License

`Valkyrie::Redis` is available under [the Apache 2.0 license](LICENSE).
