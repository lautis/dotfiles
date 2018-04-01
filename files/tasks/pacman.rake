desc 'Pacman (Arch Linux package manager)'
task pacman: ['pacman:aurman', 'pacman:bundle']

AURMAN_URL = 'https://aur.archlinux.org/cgit/aur.git/snapshot/aurman.tar.gz'.freeze

namespace :pacman do
  task :aurman do
    next if command?('aurman')
    `sudo pacman --needed -S curl` unless command?('curl')
    Dir.chdir('/tmp') do
      `curl #{AURMAN_URL} | tar -xzv`
      Dir.chdir('aurman') { `makepkg -s && sudo pacman -U *xz` }
    end
  end

  desc "Install packages"
  task :bundle do
    packages = File.read('Arch.packages').split("\n").join(" ")
    puts `aurman --needed --noedit --noconfirm -S #{packages}`
  end
end
