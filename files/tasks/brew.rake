HOMEBREW_URL = 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'.freeze

desc 'Setup Brew'
task brew: ['brew:install', 'brew:mas', 'brew:upgrade', 'brew:bundle']

namespace :brew do
  desc 'Install homebrew'
  task :install do
    if command?('brew')
      `brew update`
    else
      `/bin/bash -c "$(curl -fsSL #{HOMEBREW_URL})" </dev/null`
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
    `brew bundle --no-lock`
  end
end
