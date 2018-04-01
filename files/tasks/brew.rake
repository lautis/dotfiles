HOMEBREW_URL = 'https://raw.githubusercontent.com/Homebrew/install/master/install'.freeze

desc 'Setup Brew'
task brew: ['brew:install', 'brew:mas', 'brew:bundle']

namespace :brew do
  desc 'Install homebrew'
  task :install do
    if `which brew`.empty?
      `/usr/bin/ruby -e "$(curl -fsSL #{HOMEBREW_URL})" </dev/null`
    end
  end

  desc 'Install Mac App Store helper'
  task :mas do
    `brew install mas` if `which mas`.empty?
  end

  desc 'Install must have packages'
  task :bundle do
    `brew bundle`
  end
end
