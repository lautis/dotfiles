require 'rake'

INSTALL_RUBY_VERSION = '2.4.1'.freeze
HOMEBREW_URL = 'https://raw.githubusercontent.com/Homebrew/install/master/install'.freeze
SPACESHIP_URL = 'https://raw.githubusercontent.com/denysdovhan/spaceship-zsh-theme/master/spaceship.zsh'.freeze
FAST_AUTOCOMPLETE_REPO = 'git@github.com:zdharma/fast-syntax-highlighting.git'.freeze
OH_MY_ZSH_REPO = 'git@github.com:robbyrussell/oh-my-zsh.git'.freeze

def osascript(script)
  system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
end

task default: %i[symlink homebrew packages xcode zsh ruby java node rust atom
                 pygments terminal macos]

desc 'Symlink configuration files to local directory'
task :symlink do
  Dir.glob('**/*').each do |file|
    next if %w[Brewfile Rakefile README.md LICENSE.txt].include? file
    next if file.start_with?('files', '.')
    next if File.directory? file
    source = File.expand_path file
    target = File.join ENV['HOME'], '.' + file
    FileUtils::Verbose.mkdir_p File.dirname(target)
    FileUtils::Verbose.ln_sf source, target
  end
end

desc 'Configure ZSH'
task zsh: ['zsh:oh_my_zsh', 'zsh:spaceship', 'zsh:set_default', 'zsh:fast_syntax_highlighting']

namespace :zsh do
  desc 'Install ZSH Spaceship theme'
  task :spaceship do
    themes_dir = File.join(ENV['HOME'], '.oh-my-zsh', 'custom', 'themes')
    FileUtils::Verbose.mkdir_p(themes_dir)
    `curl -o ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme #{SPACESHIP_URL}`
  end

  desc 'Install Oh My ZSH'
  task :oh_my_zsh do
    if File.directory?(File.join(ENV['HOME'], '.oh-my-zsh', '.git'))
      puts 'Oh-My-ZSH already installed'
    else
      `git clone --bare #{OH_MY_ZSH_REPO} ~/.oh-my-zsh/.git`
      Dir.chdir(File.join(ENV['HOME'], '.oh-my-zsh')) do
        `git config core.bare false`
        `git checkout master`
      end
    end
  end

  task :fast_syntax_highlighting do
    plugin_path = File.join(ENV['HOME'], '.oh-my-zsh', 'custom', 'plugins', 'fast-syntax-highlighting')
    if File.directory?(plugin_path)
      `git -C #{plugin_path} pull`
    else
      `git clone #{FAST_AUTOCOMPLETE_REPO} #{plugin_path}`
    end
  end

  desc 'Change default shell to ZSH'
  task :set_default do
    `chsh -s /bin/zsh`
  end
end

desc 'Install Ruby'
task ruby: ['ruby:install', 'ruby:set_default', 'ruby:configure_bundler']

namespace :ruby do
  task :install do
    command = 'CFLAGS="-march=native -Os" ' \
      'RUBY_CONFIGURE_OPTS=--with-readline-dir="$(brew --prefix readline)" ' \
      "rbenv install #{INSTALL_RUBY_VERSION}"
    system command
  end

  task :set_default do
    `rbenv global #{INSTALL_RUBY_VERSION}`
  end

  task :configure_bundler do
    # Bundler is instelled via rbenv default gems plugin
    number_of_cores = `sysctl -n hw.ncpu`
    `eval "$(rbenv init -)"; gem install bundler;bundle config --global jobs #{number_of_cores.chomp.to_i - 1}`
  end
end

desc 'Install homebrew'
task :homebrew do
  `/usr/bin/ruby -e "$(curl -fsSL #{HOMEBREW_URL})" </dev/null` if `which brew`.empty?
  `brew install mas`
end

desc 'Install Xcode tools'
task :xcode do
  `xcode-select --install`
end

desc 'Setup JEnv Java versions'
task :java do
  Dir['/Library/Java/JavaVirtualMachines/*'].each do |jdk_path|
    `jenv add #{jdk_path}/Contents/Home`
  end
end

desc 'Install latest Node'
task node: ['node:install', 'node:set_default', 'node:install_flow']

namespace :node do
  task :install do
    `nodenv install $(nodenv install --list|grep '\s[0-9]'| tail -n 1)`
  end

  task :set_default do
    `nodenv global $(nodenv install --list|grep '\s[0-9]'| tail -n 1)`
  end

  task :install_flow do
    `npm install -g flow`
  end
end

task rust: ['rust:rustup', 'rust:download_sources']

namespace :rust do
  task :rustup do
    # Path is set in zshenv
    `curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path`
  end

  task :download_sources do
    `#{ENV['HOME']}/.cargo/bin/rustup component add rust-src`
  end
end

desc 'Install must have packages'
task :packages do
  `brew bundle`
end

desc 'Setup atom sync'
task atom: ['atom:sync_settings', 'atom:config']

def atom_config_file
  File.join(ENV['HOME'], '.atom', 'config.cson')
end

def atom_base_config_file
  'files/atom.cson'
end

def atom_base_config
  File.read(atom_base_config_file)
end

def configure_atom?
  return false if File.exist?(atom_config_file)
  unless File.exist?(atom_base_config_file)
    warn 'Atom base configuration file does not exist'
    return false
  end
  true
end

namespace :atom do
  task :sync_settings do
    path = '/Applications/Atom.app/Contents/Resources/app/apm/node_modules/.bin'
    `#{path}/apm install sync-settings`
  end

  task :config do
    next unless configure_atom?
    FileUtils::Verbose.mkdir_p(File.dirname(atom_config_file))
    File.open(atom_config_file, 'a') { |f| f.write(atom_base_config) }
  end
end

desc 'Install pygments'
task :pygments do
  `sudo easy_install Pygments`
end

desc 'Configure Terminal.app'
task :terminal do
  `open files/Brewer.terminal`
  osascript <<-END
    tell application "Terminal"
      set default settings to settings set "Brewer"
    end tell
  END
end

desc 'MacOS settings'
task :macos do
  `./files/defaults`
end
