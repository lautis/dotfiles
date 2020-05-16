task arch: ['arch:locale_gen', 'arch:nano_symlink']

namespace :arch do
  task :nano_symlink do
    `mkdir -p ~/.config/nano`
    `ln -fs /usr/share/nano ~/.config/nano/share`
  end

  task :locale_gen do
    locale = 'en_GB.UTF-8 UTF-8'
    next if File.read('/etc/locale.gen').match(/^#{locale}/)

    `echo '#{locale}' | sudo tee -a /etc/locale.gen`
    `sudo locale-gen`
  end
end
