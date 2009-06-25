dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("#{dir}/../pre_commit/lib"))
require "pre_commit"

task :default => :pre_commit

desc "Run precommit for all installed versions of Rails"
task :pre_commit do
  tasks.pre_commit
end

def tasks
  PreCommit::RspecOnRails.new(self)
end