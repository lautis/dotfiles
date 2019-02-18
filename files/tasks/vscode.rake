def vscode_config_base_path
  if RUBY_PLATFORM =~ /darwin/
    File.join(ENV['HOME'], 'Library', 'Application Support')
  else
    File.join(ENV['HOME'], '.config')
  end
end

def vscode_sync_settings_base_config
  'files/vscode.json'
end

def vscode_config_path
  File.join(vscode_config_base_path, 'Code', 'User')
end

def vscode_sync_settings_config
  File.join(vscode_config_path, 'syncLocalSettings.json')
end

def configure_vscode_sync_settings?
  return false if File.exist?(vscode_sync_settings_config)

  if File.exist?(vscode_sync_settings_base_config)
    true
  else
    warn 'Visual Studio Code base configuration file does not exist'
    false
  end
end

namespace :vscode do
  desc 'Install VSCode settings sync extension'
  task :install_sync_extension do
    `code --install-extension Shan.code-settings-sync`
  end

  desc 'Configure VSCode settings sync'
  task :copy_sync_settings do
    next unless configure_vscode_sync_settings?

    FileUtils::Verbose.mkdir_p(File.dirname(vscode_config_path))
    FileUtils::Verbose.cp(vscode_sync_settings_base_config, vscode_sync_settings_config)
  end
end

desc "Setup VSCode settings sync"
task vscode: ["vscode:install_sync_extension", "vscode:copy_sync_settings"]