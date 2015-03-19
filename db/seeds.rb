# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'open-uri'

markdown_repos = ["rails/rails", "capistrano/capistrano" , "orientechnologies/orientdb"]

markdown_repos.each_with_index do |repo, index|
  body = open("https://raw.githubusercontent.com/#{repo}/master/README.md") { |page| page.read }
  Article.create title: repo, body: body, created_at: Time.now - (11 * index).hours
end
