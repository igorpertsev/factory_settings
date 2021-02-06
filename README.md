# FactorySettings

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/factory_settings`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'factory_settings'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install factory_settings

## Usage

In order to use factory settings gem please initialize it in you Ruby/Rails application by adding to gems list. 
By default existing names list will be stored on hard disk of your computer alongside with gem itself. Directory can be changed by passing configuration parameter `file_storage_path` on initialize or by setting your own storage class on initialize. It can be done as following

```ruby
    FactorySettings.config do |config|
        config.file_storage_path = <your_storage_pass>
        config.name_storage = <your_storage_class>
    end
```

Please note, that storage class required to implement at least 3 methods, :add!, :remove and :exists? with single parameter (name) in each. Otherwise exception will be raised. 

To initialize new robot simply create `FactorySettings::Robot` instance. New name will be assigned automaticaly.

To reset robot's name call `reset!` on robot instance. It will remove name from robot instance and from storage. New name will be assigned automatically on next `name` request.

Client can include `FactorySettings::NameCreateSupport` module to any class in order to provide this class same robot naming logic as it described in task. 
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/factory_settings.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
