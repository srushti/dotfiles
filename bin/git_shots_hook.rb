#!/usr/bin/ruby
# frozen_string_literal: true

# A script to run takes git shots on every commit. Can be run on
# the current dir, called from a git callback, or install itself as a
# git post-commit callback.

require 'fileutils'
require 'time'

HOOKS = %w[post-commit].freeze
HOOKS_DIR = '.git/hooks'
GIT_SHOTS_DIR = "#{ENV['HOME']}/Library/CloudStorage/Dropbox/Photos/gitshots"

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
  # Default to first camera (0) - MacBook Pro Camera
  # Use ffmpeg to list devices and pick the first non-Desk View camera
  cameras = `ffmpeg -f avfoundation -list_devices true -i "" 2>&1`.split("\n")
  cameras.each do |line|
    # Look for cameras that are not "Desk View Camera"
    if line =~ /\[(\d+)\]\s+(.+)$/ && !line.include?('Desk View')
      return $1.to_i
    end
  end
  0 # Default to first camera
end

def file_path
  year = Time.now.strftime('%Y')
  month = Time.now.strftime('%m')
  FileUtils.mkdir_p("#{GIT_SHOTS_DIR}/#{year}/#{month}")
  "#{GIT_SHOTS_DIR}/#{year}/#{month}/#{Time.now.strftime('%Y%m%d%H%M%S')}.jpg"
end

def recent_shot?
  year = Time.now.year
  month = Time.now.strftime('%m')

  # Check current month
  latest = Dir.glob("#{GIT_SHOTS_DIR}/#{year}/#{month}/*.jpg").max

  # Check previous month if we are in the first hour of the new month
  if latest.nil? && Time.now.day == 1 && Time.now.hour.zero?
    prev_time = Time.now - 86_400
    prev_year = prev_time.year
    prev_month = prev_time.strftime('%m')
    latest = Dir.glob("#{GIT_SHOTS_DIR}/#{prev_year}/#{prev_month}/*.jpg").max
  end

  return false unless latest

  begin
    # Filename format: YYYYMMDDHHMMSS.jpg
    shot_time = Time.strptime(File.basename(latest, '.jpg'), '%Y%m%d%H%M%S')
    (Time.now - shot_time) < 3600
  rescue ArgumentError
    false
  end
end

def take_shot(run_in_background: false)
  return if File.directory?(File.expand_path('../rebase-merge', __dir__))

  return if recent_shot?

  # puts "Taking capture into #{file_path}!"
  # Using ffmpeg for capture (more reliable on modern macOS)
  # -f avfoundation: use macOS AVFoundation
  # -video_size 1280x720: reasonable resolution
  # -framerate 30: required framerate for the camera
  # -i "0": use first camera (MacBook Pro Camera)
  # -frames:v 1: capture only one frame
  camera_id = pick_camera
  command = "ffmpeg -f avfoundation -video_size 1280x720 -framerate 30 -i \"#{camera_id}\" -frames:v 1 -update 1 \"#{file_path}\" 2>/dev/null"

  if run_in_background
    # Run in background and detach
    pid = spawn(command, %i[out err] => '/dev/null')
    Process.detach(pid)
  else
    system command
  end
rescue StandardError
  puts 'Git shot failed'
end

def delete_hook(hook)
  File.delete(hook) if File.exist?(hook)
end

def install_hook(hook)
  if File.exist?(hook)
    $stderr.print "A file already exists at #{hook}, and will NOT be replaced.
"
    return
  end

  print "Linking #{__FILE__} to #{hook}
"
  `ln -s #{__FILE__} #{hook}`
end

if ARGV.first == '-i'
  install
elsif ARGV.first == '-r'
  reinstall
else
  take_shot run_in_background: HOOKS.include?(File.basename(__FILE__))
end
