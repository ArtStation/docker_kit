# KuberKit

[![Codeship Status for ArtStation/kuber_kit](https://app.codeship.com/projects/1286f0a6-3f90-4c1b-b426-721ed8a6571b/status?branch=master)](https://app.codeship.com/projects/417264)

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
