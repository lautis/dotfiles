require_relative '../versions'

def number_of_cores
  if RUBY_PLATFORM.include?('darwin')
    `sysctl -n hw.ncpu`
  else
    `nproc --all`
  end.chomp.to_i
end

def latest_stable_ruby_version
  latest_stable_version(`ruby-build --definitions`.split("\n"))
end

desc 'Install Ruby'
task ruby: ['ruby:install', 'ruby:set_default', 'ruby:configure_bundler']

namespace :ruby do
  task :install do
    command = 'CFLAGS="-march=native -Os" ' \
      'RUBY_CONFIGURE_OPTS=--with-readline-dir="$(brew --prefix readline)" ' \
      "rbenv install #{latest_stable_ruby_version}"
    system command
  end

  task :set_default do
    `rbenv global #{latest_stable_ruby_version}`
  end

  task :configure_bundler do
    # Bundler is instelled via rbenv default gems plugin
    jobs = [number_of_cores - 1, 1].max
    `
      eval "$(rbenv init -)";
      gem install bundler;
      bundle config --global jobs #{jobs}
    `
  end
end
