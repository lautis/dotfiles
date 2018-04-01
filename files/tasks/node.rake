require_relative '../versions'

def latest_stable_node_version
  latest_stable_version(`nodenv install --list`.split("\n"))
end

desc 'Setup Node'
task node: ['node:install', 'node:set_default']

namespace :node do
  desc 'Install latest Node.js'
  task :install do
    `nodenv install -s #{latest_stable_node_version}`
  end

  desc 'Set default Node.js version for nodenv'
  task :set_default do
    `nodenv global #{latest_stable_node_version}`
  end
end
