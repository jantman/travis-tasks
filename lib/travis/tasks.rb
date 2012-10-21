require 'bundler/setup'
require 'travis'
require 'core_ext/module/load_constants'

$stdout.sync = true

Sidekiq.configure_server do |config|
  config.redis = {
    :url       => Travis.config.redis.url,
    :namespace => Travis.config.sidekiq.namespace
  }
  config.options[:queues] = %w(campfire email flowdock github_commit_status hipchat irc pusher webhook)
end

GH::DefaultStack.options[:ssl] = Travis.config.ssl
Travis.config.update_periodically

Travis::Features.start
Travis::Exceptions::Reporter.start
Travis::Notification.setup
Travis::Mailer.setup

# Travis::Memory.new(:tasks).report_periodically if Travis.env == 'production'
# NewRelic.start if File.exists?('config/newrelic.yml')


