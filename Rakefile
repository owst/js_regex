# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task mutate: :spec do
  `bundle exec codeclimate-test-reporter` if ENV['TRAVIS']

  arguments = %w(
    bundle exec mutant
    --fail-fast
    --include lib
    --require js_regex
    --use rspec
    --ignore-subject JsRegex::Conversion#initialize
    --ignore-subject JsRegex::Converter::Context*
    -- JsRegex*
  )

  system(*arguments) || raise('Mutant task is not successful')
end

require_relative 'build'

task default: (JsRegex::PERFORM_FULL_BUILD ? :mutate : :spec)
