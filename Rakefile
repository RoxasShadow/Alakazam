#! /usr/bin/env ruby
require 'rake'

task :default => [ :build, :install, :test ]

task :build do
  sh 'gem build   *.gemspec'
end

task :install do
  sh 'gem install --no-force rspec'
  sh 'gem install *.gem'
end

task :test do
  FileUtils.cd 'tests' do
    sh 'rspec alakazam_spec.rb --backtrace --color --format doc'
  end
end