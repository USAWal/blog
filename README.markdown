Blog application [![Build Status](https://travis-ci.org/USAWal/blog.svg?branch=master)](https://travis-ci.org/USAWal/blog)
================


Description
-----------

This blog application is yet another blog implementation. I was requested to do this as a homework assignment. Inspired by this challenge and equipped with Ruby technologies I've created this code.

Features
--------

* [x] Simple blog with articles
* [x] The article body shoudl be written and rendered Markdown. body field contains raw Markdown, html_body contains rendered body (it avoids converting on each request), text_body contains only text form html_body (for list)
* [x] Articles should have comments (And more! They have them tree like. Investigate Article comments_tree class instance method. Requests to DB are optimized and it's constant)
* [x] Visitors should be able to subscribe to the site with email. (And more! The can edit their profiles)
* [x] Each time an article is posted, subscribers should be sent notification. ( Don't forget to turn notifications on and run Sidekiq)
* [x] Each email should contain a link to the article and another to 
* [x] unsubscribe (Implemented as GET link. It's not good even pretty widespread, beacuse GET method should not to change anything)
* [x] Cover the code with test where you feel appropriate (Because I'm fan of BDD, I feel it appropriate anywere where I write code. Please, take a look into the /spec folder, it took me a lot of time to support test base)

Suggested spec extensions
-------------------------

* SEO-friendly article URLs ( I've used friendlyId gem which makes meaningful ids based on a one of the fields)
* An admin panel ( I had not enough time to implement this. Usually I use ActiveAdmin as standard way)
* Front-end styling and interaction (Bootstrap3. Bootflat which is really nice, and some of my code for comments creation)
* Asynchronous email deliver (Rails 4 provides unified way for mailer backing. I used sidekiq for queueing)
* A developement envifonment setup script ( I didn't have enought time to implelent, but I added here section with steps before running )
* HTTP/fragment ( Not implemented. Rails has standard way for this optimization. Etag, caching actions, cahcing fragments with choosing storage)

Constraints
-----------

* Latest version of Ruby and Rails. ( The latest stable versions of Ruby was 2.2.0, and RoR framework was v4.2.0)
* Erb rather than HAML (Despite I find it cumbersome I used it, but actually I preffer using Slim or HAML that are concise and expressive)
* R-Spec rather than Test::Unit
* Postgres rather than MySQL
* Semantic, accessible HTML5
* CoffeeScript rather than JavaScript
* Sass rather then CSS

The things you should keep in mind before starting
--------------------------------------------------

* git clone the project
* install ruby 2.2.0
* bundle install
* run Postgresql
* run Redis
* createdb blog_development`
* createdb blog_test`
* `bundle exec rake db:create db:migrate db:seed`
* `bundle exec sidekiq -q default -q mailers`
* `bundle exec rails s`

You didn't not implement admin page, how can I add an article?
--------------------------------------------------------------

`bundle exec rake articles:create`
