task arch: ['arch:locale_gen']

namespace :arch do
  task :locale_gen do
    locale = "en_GB.UTF-8 UTF-8"
    next if File.read("/etc/locale.gen").match(/^#{locale}/)

    `echo '#{locale}' | sudo tee -a /etc/locale.gen`
    `sudo locale-gen
  end
end
