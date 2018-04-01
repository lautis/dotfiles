module ZSH
  SPACESHIP_URL = 'https://github.com/denysdovhan/spaceship-prompt.git'.freeze
  FAST_AUTOCOMPLETE_REPO = 'git@github.com:zdharma/fast-syntax-highlighting.git'
                           .freeze
  OH_MY_ZSH_REPO = 'git@github.com:robbyrussell/oh-my-zsh.git'
                   .freeze
  ZSH_PATH = '/usr/local/bin/zsh'.freeze
  SHELLS_FILE = '/etc/shells'.freeze

  extend self

  def change_default_shell
    `chsh -s #{ZSH_PATH}` if ENV['SHELL'] != ZSH_PATH
  end

  def setup_oh_my_zsh
    if File.directory?(File.join(oh_my_zsh_dir, '.git'))
      puts 'Oh-My-ZSH already installed'
    else
      clone_oh_my_zsh
    end
  end

  def setup_spaceship
    FileUtils::Verbose.mkdir_p(themes_dir) unless File.exist?(themes_dir)
    clone_or_update_spaceship
    symlink_spaceship_theme
  end

  def setup_fast_syntax_highlighting
    plugin_path = File.join(plugins_dir, 'fast-syntax-highlighting')

    if File.directory?(plugin_path)
      `git -C #{plugin_path} pull`
    else
      `git clone #{FAST_AUTOCOMPLETE_REPO} #{plugin_path}`
    end
  end

  def add_shell
    return unless File.exist?(ZSH_PATH)
    unless File.read(SHELLS_FILE).include?(ZSH_PATH)
      puts 'Adding ZSH to list of acceptable shells'
      `echo #{ZSH_PATH} | sudo tee -a #{SHELLS_FILE}`
    end
  end

  private

  def oh_my_zsh_dir
    File.join(ENV['HOME'], '.oh-my-zsh')
  end

  def plugins_dir
    File.join(oh_my_zsh_dir, 'custom', 'plugins')
  end

  def themes_dir
    File.join(oh_my_zsh_dir, 'custom', 'themes')
  end

  def spaceship_dir
    File.join(themes_dir, 'spaceship-prompt')
  end

  def clone_or_update_spaceship
    if File.exist?(spaceship_dir)
      `git -C #{spaceship_dir} fetch`
    else
      `git clone #{SPACESHIP_URL} #{spaceship_dir}`
    end
  end

  def symlink_spaceship_theme
    `ln -sf spaceship-prompt/spaceship.zsh #{themes_dir}/spaceship.zsh-theme`
  end

  def clone_oh_my_zsh
    `git clone --bare #{OH_MY_ZSH_REPO} #{File.join(oh_my_zsh_dir, '.git')}`
    Dir.chdir(oh_my_zsh_dir) do
      `git config core.bare false`
      `git checkout master`
    end
  end
end

desc 'Configure ZSH'
task zsh: [
  'zsh:shell',
  'zsh:oh_my_zsh',
  'zsh:spaceship',
  'zsh:set_default',
  'zsh:fast_syntax_highlighting'
]

namespace :zsh do
  desc 'Add Homebrew ZSH to list of acceptable shells'
  task(:shell) { ZSH.add_shell }

  desc 'Install ZSH Spaceship theme'
  task(:spaceship) { ZSH.setup_spaceship }

  desc 'Install Oh My ZSH'
  task(:oh_my_zsh) { ZSH.setup_oh_my_zsh }

  task(:fast_syntax_highlighting) { ZSH.setup_fast_syntax_highlighting }

  desc 'Change default shell to ZSH'
  task(:set_default) { ZSH.change_default_shell }
end
