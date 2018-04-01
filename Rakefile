require 'rake'
Dir.glob('files/tasks/*.rake').each { |r| load r }

def osascript(script)
  system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
end

task default: %i[
  symlink brew xcode zsh ruby java node rust atom pygments
  terminal macos
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

desc 'Install pygments'
task :pygments do
  `sudo easy_install Pygments`
end

desc 'Configure Terminal.app'
task :terminal do
  `open files/Brewer.terminal`
  osascript <<-OSASCRIPT
    tell application "Terminal"
      set default settings to settings set "Brewer"
    end tell
  OSASCRIPT
end

desc 'MacOS settings'
task :macos do
  `./files/defaults`
end
