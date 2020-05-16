task rust: [
  'rust:rustup',
  'rust:install',
  'rust:download_sources',
  'rust:rustfmt'
]

namespace :rust do
  task :rustup do
    # Path is set in zshenv
    if !command?('rustup') && command?('rustup-init')
      `rustup-init -y --no-modify-path`
    elsif !command?('rustup')
      `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
    else
      `rustup update`
    end
  end

  task :install do
    `$HOME/.cargo/bin/rustup install stable`
    `$HOME/.cargo/bin/rustup install nightly`
    `$HOME/.cargo/bin/rustup default stable`
  end

  task :rustfmt do
    unless RUBY_PLATFORM.include?('armv')
      `$HOME/.cargo/bin/rustup component add rustfmt --toolchain nightly`
    end
  end

  task :clippy do
    unless RUBY_PLATFORM.include?('armv')
      `$HOME/.cargo/bin/cargo +nightly install clippy`
    end
  end

  task :download_sources do
    `$HOME/.cargo/bin/rustup component add rust-src`
  end
end
