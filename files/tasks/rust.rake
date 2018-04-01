task rust: ['rust:rustup', 'rust:download_sources']

namespace :rust do
  task :rustup do
    # Path is set in zshenv
    if `which rustup`.empty?
      `curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path`
    else
      `rustup update`
    end
  end
  end

  task :download_sources do
    `#{ENV['HOME']}/.cargo/bin/rustup component add rust-src`
  end
end
