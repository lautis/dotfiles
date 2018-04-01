require 'rake'
Dir.glob('files/tasks/*.rake').each { |r| load r }

task common: %i[zsh ruby node rust]

desc 'Run everything on Mac'
task mac: %i[symlink brew macos:xcode common java atom macos]

desc 'Run everything on Arch Linux'
task arch: %i[symlink pacman common]

desc 'Run everything on (generic) Linux'
task linux: %i[symlink common]

task default: :mac
