task rust: [
  'rust:rustup',
  'rust:install',
  'rust:download_sources',
  'rust:rustfmt',
  'rust:clippy'
]

namespace :rust do
  task :rustup do
    # Path is set in zshenv
    if `which rustup`.empty? && `which rustup-init`.empty?
      `curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path`
    elsif `which rustup`.empty?
      `rustup-init -y --no-modify-path`
    else
      `rustup update`
    end
  end

  task :install do
    `rustup install stable`
  end

  task :rustfmt do
    `rustup component add rustfmt-preview`
  end

  task :clippy do
    `cargo +nightly install clippy`
  end

  task :download_sources do
    `#{ENV['HOME']}/.cargo/bin/rustup component add rust-src`
  end
end
