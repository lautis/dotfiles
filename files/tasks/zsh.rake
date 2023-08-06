require 'shellwords'

module ZSH
  OH_MY_ZSH_REPO = 'https://github.com/ohmyzsh/ohmyzsh.git'
                   .freeze
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

  def setup_fzf
    fzf_options = '--key-bindings --completion --no-update-rc --no-bash'
    if command?('brew')
      `brew reinstall fzf`
      `$(brew --prefix)/opt/fzf/install #{fzf_options}`
    end
  end

  def add_shell
    return unless File.exist?(zsh_path)
    return if File.read(SHELLS_FILE).include?(zsh_path)

    puts 'Adding ZSH to list of acceptable shells'
    `echo #{Shellwords.escape(zsh_path)} | sudo tee -a #{SHELLS_FILE}`
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
      `echo $(brew --prefix)/bin/zsh`.chomp
    else
      '/usr/bin/zsh'
    end.freeze
  end

  def oh_my_zsh_dir
    File.join(ENV['HOME'], '.oh-my-zsh')
  end

  def themes_dir
    File.join(oh_my_zsh_dir, 'custom', 'themes')
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
  'zsh:set_default',
  'zsh:fzf'
]

namespace :zsh do
  desc 'Add Homebrew ZSH to list of acceptable shells'
  task(:shell) { ZSH.add_shell }

  desc 'Install Oh My ZSH'
  task(:oh_my_zsh) { ZSH.setup_oh_my_zsh }

  desc 'Install fzf'
  task(:fzf) { ZSH.setup_fzf }

  desc 'Install forgit'
  task(:forgit) { ZSH.setup_forgit }

  desc 'Change default shell to ZSH'
  task(:set_default) { ZSH.change_default_shell }
end
