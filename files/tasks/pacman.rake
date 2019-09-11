desc 'Pacman (Arch Linux package manager)'
task pacman: ['pacman:yay', 'pacman:bundle']

YAY_URL = 'https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz'.freeze

namespace :pacman do
  task :yay do
    next if command?('yay')
    `sudo pacman --needed --noconfirm -S base-devel curl go`
    Dir.chdir('/tmp') do
      `curl #{YAY_URL} | tar -xzv`
      Dir.chdir('/tmp/yay') { `makepkg -s && sudo pacman --noconfirm -U *xz` }
    end
  end

  desc "Install packages"
  task :bundle do
    packages = File.read('Arch.packages').split("\n").join(" ")
    puts `yay --needed --noconfirm -S #{packages}`
  end
end
