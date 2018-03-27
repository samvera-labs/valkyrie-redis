# frozen_string_literal: true
source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in valkyrie-cloud_search.gemspec
gemspec

if ENV['EDGE_VALKYRIE']
  gem 'valkyrie', github: 'samvera-labs/valkyrie'
end
