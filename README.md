# Gakubuchi

[![Gem Version](https://badge.fury.io/rb/gakubuchi.svg)](http://badge.fury.io/rb/gakubuchi)
[![Build Status](https://travis-ci.org/yasaichi/gakubuchi.svg?branch=master)](https://travis-ci.org/yasaichi/gakubuchi)
[![Code Climate](https://codeclimate.com/github/yasaichi/gakubuchi/badges/gpa.svg)](https://codeclimate.com/github/yasaichi/gakubuchi)
[![Test Coverage](https://codeclimate.com/github/yasaichi/gakubuchi/badges/coverage.svg)](https://codeclimate.com/github/yasaichi/gakubuchi/coverage)

Gakubuchi provides a simple way to manage static pages (e.g. error pages) with Asset Pipeline.

## Quickstart
Put this in your Gemfile:

```ruby
gem 'gakubuchi'
```

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

Then, you can get `public/404.html`.

## Template engines
Gakubuchi supports some template engines: `ERB`, `Haml` and `Slim`.  
If you want to use `Haml` or `Slim`, you need to put them in your Gemfile:

```ruby
# Use Haml
gem 'haml-rails'

# Use Slim
gem 'slim-rails'
```

## Configuration
First, run the installation generator with:

```shell
rails generate gakubuchi:install
```

This will install the initializer into `config/initializers/gakubuchi.rb`.

In the file, you can configure the following values.

```
remove_precompiled_templates # true by default
template_root                # 'app/assets/templates' by default
```

## Supported versions
* Ruby: `2.0.0` or later
* Rails: `4.0.0` or later

## Contributing
You should follow the steps below.

1. [Fork the repository](https://help.github.com/articles/fork-a-repo/)
2. Create a feature branch: `git checkout -b add-new-feature`
3. Commit your changes: `git commit -am 'add new feature'`
4. Push the branch: `git push origin add-new-feature`
4. [Send us a pull request](https://help.github.com/articles/using-pull-requests/)

We use [Appraisal](https://github.com/thoughtbot/appraisal) to test with different versions of Rails.  

```shell
bundle install
appraisal install

# Run rspec with a specific version of Rails
appraisal rails42x rspec

# Run rspec with all versions of Rails
appraisal rspec
```

## License

MIT License. Copyright 2015 Yuichi Goto.
