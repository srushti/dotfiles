#!/usr/bin/ruby
# frozen_string_literal: true

# A script to run takes git shots on every commit. Can be run on
# the current dir, called from a git callback, or install itself as a
# git post-commit callback.

require 'fileutils'

HOOKS = %w[post-commit].freeze
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

def pick_camera
  _, *cameras = `imagesnap -l`.split("\n").collect { |camera_name| camera_name[3..] }
  cameras.inject { |_, camera| /\[(.*)\]\[/.match(camera)[1] }
end

def file_path
  year = Time.now.strftime('%Y')
  month = Time.now.strftime('%m')
  FileUtils.mkdir_p("#{ENV['HOME']}/Dropbox/Photos/gitshots/#{year}/#{month}")
  "~/Dropbox/Photos/gitshots/#{year}/#{month}/#{Time.now.strftime('%Y%m%d%H%M%S')}.jpg"
end

def take_shot(run_in_background: false)
  return if File.directory?(File.expand_path('../rebase-merge', __dir__))

  puts "Taking capture into #{file_path}!"
  command = "ffmpeg -f avfoundation -video_size 1280x720 -framerate 30 -i '0' -vframes 1 #{file_path}"
  if run_in_background
    IO.popen(command)
  else
    system command
  end
rescue Error
  puts 'Git shot failed'
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
else
  take_shot run_in_background: HOOKS.include?(File.basename(__FILE__))
end
