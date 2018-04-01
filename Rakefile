require 'rake'
Dir.glob('files/tasks/*.rake').each { |r| load r }

task default: %i[
  symlink brew macos:xcode zsh ruby java node rust atom macos
]

task linux: %i[
  symlink zsh ruby node rust
]

def symlinked_files
  Dir.glob('**/*').select do |file|
    next false if %w[Brewfile Rakefile README.md LICENSE.txt].include? file
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

desc 'Setup JEnv Java versions'
task :java do
  Dir['/Library/Java/JavaVirtualMachines/*'].each do |jdk_path|
    `jenv add #{jdk_path}/Contents/Home`
  end
end
