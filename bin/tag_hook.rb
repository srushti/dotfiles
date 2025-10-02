#!/usr/bin/ruby
# frozen_string_literal: true

# -*-ruby-*-
# A script to run ctags on all .rb files in a project. Can be run on
# the current dir, called from a git callback, or install itself as a
# git post-merge and post-commit callback.

CTAGS = '/usr/local/bin/ctags'
HOOKS = %w[post-merge post-checkout].freeze
HOOKS_DIR = '.git/hooks'

def ensure_git_repo
  return if File.writable?(HOOKS_DIR)

  $stderr.print "The install option [-i] can only be used within a git repo; exiting.\n"
  exit 1
end

def install
  ensure_git_repo
  HOOKS.each { |hook| install_hook("#{HOOKS_DIR}/#{hook}") }
end

def reinstall
  ensure_git_repo
  HOOKS.each { |hook| delete_hook("#{HOOKS_DIR}/#{hook}") }
  install
end

def run_tags(dir, run_in_background = false)
  if File.executable?(CTAGS) && File.writable?(dir)
    if File.exist?('Gemfile')
      ctags_command = "bundle list --paths=true | xargs #{CTAGS} -L #{dir}/tags --recurse=yes #{dir}--extra=+f --exclude=.tmp exclude=node_modules --exclude=.git --exclude=public --exclude=tmp --exclude=*.js --exclude=log -R * 2>> /dev/null"
    else
      ctags_command = "ack -f | #{CTAGS} -L - 2>> /dev/null"
    end
    cmd = "#{ctags_command} && ack -f >| cscope.files && cscope -b -q#{run_in_background ? ' &' : ''}"
    $stdout.print "refreshed tags\n"
    system cmd
  else
    $stderr.print "FAILED to write TAGS file to #{dir}\n"
  end
end

def delete_hook(hook)
  File.delete(hook) if File.exist?(hook)
end

def install_hook(hook)
  if File.exist?(hook)
    $stderr.print "A file already exists at #{hook}, and will NOT be replaced.\n"
    return
  end

  print "Linking #{__FILE__} to #{hook}\n"
  `ln -s #{__FILE__} #{hook}`
end

if ARGV.first == '-i'
  install
elsif ARGV.first == '-r'
  reinstall
  # else
  #   run_tags Dir.pwd, HOOKS.include?(File.basename(__FILE__))
end
