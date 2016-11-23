# Gakubuchi

[![Gem Version](https://badge.fury.io/rb/gakubuchi.svg)](http://badge.fury.io/rb/gakubuchi)
[![Build Status](https://travis-ci.org/yasaichi/gakubuchi.svg?branch=master)](https://travis-ci.org/yasaichi/gakubuchi)
[![Code Climate](https://codeclimate.com/github/yasaichi/gakubuchi/badges/gpa.svg)](https://codeclimate.com/github/yasaichi/gakubuchi)
[![Test Coverage](https://codeclimate.com/github/yasaichi/gakubuchi/badges/coverage.svg)](https://codeclimate.com/github/yasaichi/gakubuchi/coverage)

Gakubuchi provides a simple way to manage static pages (e.g. error pages) with Asset Pipeline.

## Installation
Put this in your Gemfile:

```ruby
gem 'gakubuchi'
```

Run the installation generator with:

```shell
rails generate gakubuchi:install
```

Or specify the name of directory for static pages:

```shell
rails generate gakubuchi:install -d html
```

They will install the initializer into `config/initializers/gakubuchi.rb` and create the directory in `app/assets`.  
If you don't specify the `-d` option, `templates` will be used as default.

## Usage

In `app/assets/templates/404.html.slim`:

```slim
doctype html
html
  head
    title The page you were looking for doesn't exist (404)
    meta name='viewport' content='width=device-width,initial-scale=1'
    = stylesheet_link_tag 'application', media: 'all'
  body
    .dialog
      div
        h1 The page you were looking for doesn't exist.
        p You may have mistyped the address or the page may have moved.
      p If you are the application owner check the logs for more information.
```

Open the following URL in your browser to check the templeate:

```
http://localhost:3000/assets/404.html
```

Compile the templeate with:

```shell
rake assets:precompile
```

This will generate `public/404.html`.

## Template engines
Gakubuchi supports some template engines: `ERB`, `Haml` and `Slim`.  
If you want to use `Haml` or `Slim`, you need to put them in your Gemfile:

```ruby
# Use Haml
gem 'haml-rails'

# Use Slim
gem 'slim-rails'
```

## Using assets
Gakubuchi enables you to use assets (e.g. `CSS` or `JavaScript` files) in static pages.  
Note that you may need to add them to the precompile array in `config/initializers/assets.rb`:

```ruby
Rails.application.config.assets.precompile += %w(error.css error.js)
```

## Using helpers
You can also use helpers provided by `Sprockets::Rails::Helper` in static pages.   
Examples of them are given below.

* `asset_path`
* `content_tag`
* `favicon_link_tag`
* `image_tag`
* `javascript_include_tag`

If you want to get the list of all available helpers, please execute the following code.

```ruby
Sprockets::Rails::Helper.instance_methods
```

## Configuration
In `config/initializers/gakubuchi.rb`, you can configure the following values.

```
leave_digest_named_templates # false by default
template_directory           # 'templates' by default
```

## Contributing
You should follow the steps below.

1. [Fork the repository](https://help.github.com/articles/fork-a-repo/)
2. Create a feature branch: `git checkout -b add-new-feature`
3. Commit your changes: `git commit -am 'add new feature'`
4. Push the branch: `git push origin add-new-feature`
4. [Send us a pull request](https://help.github.com/articles/using-pull-requests/)

We use [Appraisal](https://github.com/thoughtbot/appraisal) to test with different combinations of
[sprockets](https://github.com/rails/sprockets) and [sprockets-rails](https://github.com/rails/sprockets-rails).

```shell
bundle install
appraisal install

# Run RSpec with a specific combination
appraisal sprockets_rails_3_with_sprockets_3 rspec

# Run RSpec with all combinations
appraisal rspec
```

## License

MIT License. Copyright 2015 Yuichi Goto.
