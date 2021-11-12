def osascript(script)
  system 'osascript', *script.split(/\n/).map { |line| ['-e', line] }.flatten
end

desc 'MacOS specific configuration'
task macos: ['macos:defaults', 'macos:terminal', 'macos:nano_symlink']

namespace :macos do
  task :nano_symlink do
    `mkdir -p ~/.config/nano`
    `ln -sf $(brew --prefix)/share/nano ~/.config/nano/share`
  end

  desc 'Setup xcode terminal tooling'
  task :xcode do
    `xcode-select --install`
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

  desc 'Apply MacOS default settings'
  task :defaults do
    `./files/defaults`
  end
end
