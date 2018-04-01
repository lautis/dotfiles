def symlinked_files
  Dir.glob('**/*').select do |file|
    next false if %w[Arch.packages Brewfile Rakefile README.md LICENSE.txt].include? file
    next false if file.start_with?('files', '.')
    next false if File.directory? file
    true
  end
end

desc 'Symlink configuration files to local directory'
task :symlink do
  symlinked_files.each do |file|
    source = File.expand_path file
    target = File.join ENV['HOME'], '.' + file
    FileUtils::Verbose.mkdir_p File.dirname(target)
    FileUtils::Verbose.ln_sf source, target
  end
end
