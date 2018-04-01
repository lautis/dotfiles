HOMEBREW_URL = 'https://raw.githubusercontent.com/Homebrew/install/master/install'.freeze

desc 'Setup Brew'
task brew: ['brew:install', 'brew:mas', 'brew:upgrade', 'brew:bundle']

namespace :brew do
  desc 'Install homebrew'
  task :install do
    if command?('brew')
      `/usr/bin/ruby -e "$(curl -fsSL #{HOMEBREW_URL})" </dev/null`
    else
      `brew update`
    end
  end

  desc 'Upgrade installed packages'
  task :upgrade do
    `brew upgrade`
  end

  desc 'Install Mac App Store helper'
  task :mas do
    `brew install mas` unless command?('mas')
  end

  desc 'Install must have packages'
  task :bundle do
    `brew bundle`
  end
end
