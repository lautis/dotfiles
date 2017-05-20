Pry.config.color = true

Pry.config.history.should_save = true
Pry.config.theme = "pry-modern-256"

require 'readline'
# tell Readline when the window resizes
old_winch = trap 'WINCH' do
  if `stty size` =~ /\A(\d+) (\d+)\n\z/
    Readline.set_screen_size($1.to_i, $2.to_i) rescue nil
    Readline.refresh_line
  end
  old_winch.call if old_winch.respond_to?(:call)
end

### START debundle.rb ###

# MIT License
# Copyright (c) Conrad Irwin <conrad.irwin@gmail.com>
# Copyright (c) Jan Lelis <mail@janlelis.de>

module Debundle
  VERSION = '1.1.0'

  def self.debundle!
    return unless defined?(Bundler)
    return unless Gem.post_reset_hooks.reject!{ |hook|
      hook.source_location.first =~ %r{/bundler/}
    }
    if defined? Bundler::EnvironmentPreserver
      ENV.replace(Bundler::EnvironmentPreserver.new(ENV, %w(GEM_PATH)).backup)
    end
    Gem.clear_paths

    load 'rubygems/core_ext/kernel_require.rb'
    load 'rubygems/core_ext/kernel_gem.rb'
  rescue
    warn "DEBUNDLE.RB FAILED"
    raise
  end
end

Debundle.debundle!

### END debundle.rb ###


begin
  require 'hirb'

  Pry.config.print = proc do |output, value, _pry_|
    Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value, _pry_)
  end
rescue LoadError
  # Missing goodies, bummer
end
