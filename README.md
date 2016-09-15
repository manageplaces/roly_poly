# RolyPoly

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/roly_poly`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'roly_poly'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install roly_poly

## Getting started


#### 1. Generate models

Once you've installed the gem, you will need to set it up within your application. To do this, simply run

    $ rails g roly_poly

*Note* this assumes you're happy to use the default model names, and that your existing application has a model called User.
All of these are configurable however. The full command which allows these to be changed is

    $ rails g roly_poly [RoleClass] [PermissionClass] [UserClass]


Once this has finished, your app will have 4 new models:

- Role
- Permission
- RolePermission
- UserRole

There is one migration per model above that will also be generated.

#### 2. Run migrations (ActiveRecord only)

Once you've setup RolyPoly, you simply need to run the migrations

    $ rake db:migrate

And that's it. RolyPoly is now installed into your app. You can now start setting it up.

*Please note* Whilst this step is only required if you're using ActiveRecord, RolyPoly does not currently support
mongoid. This is in the list of Todo's, however anyone willing to contribute to this effort is more than welcome.


#### 3. More to come

This documentation is incomplete, just like the gem itself. Stay tuned for more info.




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/roly_poly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
