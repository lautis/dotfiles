def symlinked_files
  Dir.glob('**/*').select do |file|
    if %w[Arch.packages Brewfile Rakefile README.md LICENSE.txt plugins].include? file
      next false
    end
    next false if file.start_with?('files', 'plugins' '.')
    next false if File.directory? file

    true
  end
end

def zsh_plugins
  Dir.entries('plugins').select do |file|
    next false if file.start_with?('.')
    true
  end
end

desc 'Symlink configuration files to local directory'
task :symlink do
  symlinked_files.each do |file|
    source = File.expand_path file
    target = File.join ENV['HOME'], '.' + file
    FileUtils::Verbose.mkdir_p File.dirname(target) unless File.exist? target
    FileUtils::Verbose.ln_sf source, target
  end

  zsh_plugins.each do |plugin|
    source = File.expand_path plugin, 'plugins'
    base_dir = File.join ENV['HOME'], '.local', 'share', 'zsh-snap', 'plugins'
    target = File.join base_dir, plugin

    FileUtils::Verbose.mkdir_p File.dirname(base_dir) unless File.exist? base_dir
    FileUtils::Verbose.ln_sf source, target
  end
end
