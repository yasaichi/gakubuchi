# Gakubuchi

[![Gem Version](https://badge.fury.io/rb/gakubuchi.svg)](http://badge.fury.io/rb/gakubuchi)
[![Build Status](https://travis-ci.org/yasaichi/gakubuchi.svg?branch=master)](https://travis-ci.org/yasaichi/gakubuchi)
[![Code Climate](https://codeclimate.com/github/yasaichi/gakubuchi/badges/gpa.svg)](https://codeclimate.com/github/yasaichi/gakubuchi)
[![Test Coverage](https://codeclimate.com/github/yasaichi/gakubuchi/badges/coverage.svg)](https://codeclimate.com/github/yasaichi/gakubuchi/coverage)

Gakubuchi is a gem which enables you to manage static pages with Asset Pipeline.

## What is Gakubuchi?

Gakubuchi provides a simple and useful framework to manage static pages (e.g. error pages).  
As it uses Asset Pipeline, you can treat them as views of Rails.

## Quickstart
Put this in your Gemfile:

```ruby
gem 'gakubuchi'
```

In `app/assets/templates/static_page.html.slim`:

```slim
doctype html
html
  head
    title
      | Sample Static Page
    = stylesheet_link_tag 'application', media: 'all'
    = javascript_include_tag 'application'
  body
    p
      | Hello, Gakubuchi!
```

Compile the templeate with:

```shell
rake assets:precompile
```

Then, you can get `public/static_page.html` as follows.

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Sample Static Page</title><link rel="stylesheet" media="all" href="/assets/application-e80e8f2318043e8af94dddc2adad5a4f09739a8ebb323b3ab31cd71d45fd9113.css" /><script src="/assets/application-8f06a73c35179188914ab50e057157639fce1401c1cdca640ac9cec33746fc5b.js"></script>
  </head>
  <body>
    <p>
      Hello, Gakubuchi!
    </p>
  </body>
</html>
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

## Supports
* Ruby: `2.0.0` or later
* Rails: `4.0.0` or later (supports `3.x` as possible)
* Template engines: `ERB`, `Haml` and `Slim`

## Contributing
You should follow the steps below.

1. Fork the repository
2. Create a feature branch
3. Submit the pull request

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
