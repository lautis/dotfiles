require 'rake'
Dir.glob('files/tasks/*.rake').each { |r| load r }

desc 'Run everything on Mac'
task mac: %i[symlink brew macos:xcode zsh ruby java node rust atom macos]

desc 'Run everything on Linux'
task linux: %i[symlink zsh ruby node rust]

task default: :mac
