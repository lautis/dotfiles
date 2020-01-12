require 'shellwords'

module ZSH
  SPACESHIP_URL = 'https://github.com/denysdovhan/spaceship-prompt.git'.freeze
  EMOJI_CLI_REPO = 'https://github.com/b4b4r07/emoji-cli.git'.freeze
  FAST_AUTOCOMPLETE_REPO = 'https://github.com/zdharma/fast-syntax-highlighting.git'
                           .freeze
  OH_MY_ZSH_REPO = 'https://github.com/ohmyzsh/ohmyzsh.git'
                   .freeze
  FZF_REPO = 'https://github.com/junegunn/fzf.git'.freeze
  SHELLS_FILE = '/etc/shells'.freeze

  extend self

  def change_default_shell
    `chsh -s #{Shellwords.escape(zsh_path)}` if ENV['SHELL'] != zsh_path
  end

  def setup_oh_my_zsh
    if File.directory?(File.join(oh_my_zsh_dir, '.git'))
      `git -C #{Shellwords.escape(oh_my_zsh_dir)} pull`
    else
      clone_oh_my_zsh
    end
  end

  def setup_spaceship
    FileUtils::Verbose.mkdir_p(themes_dir) unless File.exist?(themes_dir)
    clone_or_update_spaceship
    symlink_spaceship_theme
  end

  def setup_emoji_cli
    clone_or_update(EMOJI_CLI_REPO, emoji_cli_dir)
  end

  def setup_fzf
    fzf_options = '--key-bindings --completion --no-update-rc --no-bash'
    if command?('brew')
      `brew reinstall fzf`
      `$(brew --prefix)/opt/fzf/install #{fzf_options}`
    else
      clone_or_update(FZF_REPO, File.join(ENV['HOME'], '.fzf'))
      `~/.fzf/install #{fzf_options}`
    end
  end

  def setup_fast_syntax_highlighting
    plugin_path = File.join(plugins_dir, 'fast-syntax-highlighting')
    clone_or_update(FAST_AUTOCOMPLETE_REPO, plugin_path)
  end

  def add_shell
    return unless File.exist?(zsh_path)
    return if File.read(SHELLS_FILE).include?(zsh_path)

    puts 'Adding ZSH to list of acceptable shells'
    `echo #{Shellwords.esape(zsh_path)} | sudo tee -a #{SHELLS_FILE}`
  end

  private

  def clone_or_update(repo_url, directory)
    if File.exist?(directory)
      `git -C #{Shellwords.escape(directory)} remote set-url origin #{Shellwords.escape(repo_url)}`
      `git -C #{Shellwords.escape(directory)} pull`
    else
      `git clone #{Shellwords.escape(repo_url)} #{Shellwords.escape(directory)}`
    end
  end

  def zsh_path
    if RUBY_PLATFORM.include?('darwin')
      '/usr/local/bin/zsh'
    else
      '/usr/bin/zsh'
    end.freeze
  end

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

  def emoji_cli_dir
    File.join(plugins_dir, 'emoji-cli')
  end

  def clone_or_update_spaceship
    clone_or_update(SPACESHIP_URL, spaceship_dir)
  end

  def symlink_spaceship_theme
    theme_path = File.join(themes_dir, "spaceship.zsh-theme")
    `ln -sf spaceship-prompt/spaceship.zsh #{Shellwords.escape(theme_path)}`
  end

  def clone_oh_my_zsh
    zsh_git_path = File.join(oh_my_zsh_dir, '.git')
    `git clone --bare #{Shellwords.escape(OH_MY_ZSH_REPO)} #{Shellwords.escape(zsh_git_path)}`
    `git -C #{oh_my_zsh_dir} config core.bare false`
    `git -C #{oh_my_zsh_dir} checkout master`
  end
end

desc 'Configure ZSH'
task zsh: [
  'zsh:shell',
  'zsh:oh_my_zsh',
  'zsh:spaceship',
  'zsh:set_default',
  'zsh:fast_syntax_highlighting',
  'zsh:fzf',
  'zsh:emoji_cli'
]

namespace :zsh do
  desc 'Add Homebrew ZSH to list of acceptable shells'
  task(:shell) { ZSH.add_shell }

  desc 'Install ZSH Spaceship theme'
  task(:spaceship) { ZSH.setup_spaceship }

  desc 'Install Oh My ZSH'
  task(:oh_my_zsh) { ZSH.setup_oh_my_zsh }

  task(:fast_syntax_highlighting) { ZSH.setup_fast_syntax_highlighting }

  desc 'Install emoji-cli'
  task(:emoji_cli) { ZSH.setup_emoji_cli }

  desc 'Install fzf'
  task(:fzf) { ZSH.setup_fzf }

  desc 'Change default shell to ZSH'
  task(:set_default) { ZSH.change_default_shell }
end
