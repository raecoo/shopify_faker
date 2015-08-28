# ShopifyFaker

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/shopify_faker`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shopify_faker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shopify_faker

## Usage

This is primarily intended for testing suites, though you can also use this
to generate fake data for staging environments.

Currently, only the Fabrication gem is supported. You do this with:

```
require 'shopify_faker/blueprints/fabrication.rb'
```

Drop this in `rails_helper` or something similar.

There are also helpers that will work with RSpec:

```
include ShopifyFaker::RSPec::Fabrication
```

in an example group.

To generate a fake product data:

```
attributes_for(:shopify_product, title: 'something')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/shopify_faker.

