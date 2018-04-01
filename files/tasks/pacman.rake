desc 'Pacman (Arch Linux package manager)'
task pacman: ['pacman:bundle']

namespace :pacman do
  desc "Install packages"
  task :bundle do
    packages = File.read('Arch.packages').split("\n").join(" ")
    puts `aurman --needed --noedit --noconfirm -S #{packages}`
  end
end
