# KuberKit

[![Rspec](https://github.com/ArtStation/kuber_kit/workflows/Rspec/badge.svg)](https://github.com/ArtStation/kuber_kit/actions?query=workflow%3ARspec)

Solution for building & deploying applications on Kubernetes, written in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kuber_kit'
```

## Development

### Launch compilation

```
bundle exec bin/kit compile ruby_app,ruby_app2 --path=./example
```

### Launch deployment

```
bundle exec bin/kit compile -s ruby_app,ruby_app2 --path=./example
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
