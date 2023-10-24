# KuberKit

[![Rspec](https://github.com/ArtStation/kuber_kit/workflows/Rspec/badge.svg)](https://github.com/ArtStation/kuber_kit/actions?query=workflow%3ARspec)

Solution for building & deploying applications on Kubernetes, written in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kuber_kit'
```

## Ruby versions

Please install specific kuber_kit version, depending on Ruby version.

| Ruby Version | KuberKit Version |
| ------------ | ------------ |
| 2.6 | 1.0.1 |
| 2.7 | 1.1.7 |
| > 3.0 | 1.3.5 |

## Usage

### Available commands

* `kit apply FILE_PATH` - Apply FILE_PATH with kubectl. Doesn't guarantee service restart. E.g. `kit apply -C community ~/.kuber_kit/services/main_app_sidekiq.yml`.
* `kit attach` - Attach to POD_NAME. E.g. `kit attach -C community main-app-sidekiq-797646db88-7s4g7`
* `kit compile IMAGE_NAMES` - Compile image with IMAGE_NAMES (comma-separated), and pushes to registry. Does not launch service. E.g. `kit compile -C community main_app_sidekiq`
* `kit console POD_NAME` - Attach to POD_NAME & launch bin/console. E.g. `kit console -C community main-app-sidekiq-797646db88-7s4g7`
* `kit deploy` - Deploy all services
* `kit env ENV_FILE_NAME` - Return content of Env File ENV_FILE_NAME, where ENV_FILE_NAME artifact added by `KuberKit.add_env_file` in config files. E.g. `kit env -C community env_rke_community`
* `kit help [COMMAND]` - Describe available commands or one specific command
* `kit logs POD_NAME` - Show logs for POD_NAME. E.g. `kit logs -C community main-app-sidekiq-797646db88-7s4g7`
* `kit service SERVICE_NAME` - Return content of Service. E.g. `kit service -C community main_app_sidekiq`
* `kit template TEMPLATE_NAME` - Return content of Template. E.g. `kit template -C community web_app`
* `kit version` - Print current version

### Deploy Specific services

* `kit deploy -t blogging` - Deploy all services with tag blogging
* `kit deploy -s blogging_app` - Deploy service with name blogging_app
* `kit deploy -s *_app` - Deploy all services with name ending `_app`
* `kit deploy -t blogging -s ^*_app` - Deploy all services with tag blogging, except ones ending with `_app`

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
