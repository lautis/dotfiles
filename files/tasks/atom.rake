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

desc 'Setup atom sync'
task atom: ['atom:sync_settings', 'atom:config']

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
