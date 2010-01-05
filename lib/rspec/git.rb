module RSpec
  class Git
    def repos_fetched?
      repos.all? do |repo|
        if File.directory?(repo[:path])
          true
        else
          $stderr.puts "missing #{repo[:path]}"
          false
        end
      end
    end
    
    def update
      check_for_clean_repos "Unable to update"
      
      repos.each do |r|
        if File.exist?(r[:path])
          puts "** Updating #{r[:name]}"
          target = ENV['REMOTE'] ? "#{ENV['REMOTE']} master" : ""
          unless system("cd #{r[:path]} && git pull --rebase #{target}")
            puts "Error updating #{r[:name]}"
            exit 1
          end
        else
          puts "** Fetching #{r[:name]}"
          system "git clone #{r[:url]} #{r[:path]}"
        end
      end
      puts "*** all repos updated successfully ***"
    end
    
    def status
      repos.each do |r|
        puts "\n** #{r[:name]} status"
        system "cd #{r[:path]} && git status"
      end
    end

    def push
      check_for_clean_repos "Unable to push"

      repos.each do |r|
        puts "** push #{r[:name]}"
        unless system("cd #{r[:path]} && git push && git push --tags")
          puts "Error pushing #{r[:name]}"
          exit 1
        end
      end
      puts "Successfully pushed changes to github"
    end

    def commit
      if ENV['MESSAGE'].nil?
        puts "You must pass a commit message.  Try it again with:\n" +
          "rake git:commit MESSAGE='commit message here'"
        return
      end
      
      repos.each do |r|
        output = `cd #{r[:path]} && git status`
        unless output.include?('On branch master')
          puts "*** #{r[:name]} is not on the master branch.  Skipping"
          next
        end
        puts "** Committing #{r[:name]}"
        system "cd #{r[:path]} && git commit -a -m #{ENV['MESSAGE'].inspect}"
      end
    end

    def hard_reset
      repos.each do |r|
        puts "\n** Resetting #{r[:name]}"
        system "cd #{r[:path]} && git add . && git reset --hard"
      end
      puts
    end

    def add_remotes
      if ENV['REPO_PREFIX'].nil? || ENV['NAME'].nil?
        puts "You must pass a prefix and name.  Try it again with (e.g.):\n" +
          "rake git:add_remotes REPO_PREFIX='git://github.com/dchelimsky' NAME='dc'"
        return
      end

      repos.each do |r|
        system "cd #{r[:path]} && git remote add #{ENV['NAME']} #{r[:url]}"
      end
    end
    
    def tag
      if ENV['TAG'].nil?
        puts "You must pass a tag. Try again like so:\n" +
          "  TAG=1.1.4 rake git:tag"
        return
      end
      repos.each do |r|
        system "cd #{r[:path]} && git tag #{ENV['TAG']}"
      end
    end

    def repos
      @yaml ||= begin
                  repos_yml_path = File.join(File.dirname(__FILE__), "/../../repos.yml")
                  unless File.exists?(repos_yml_path)
                    $stderr.puts "Missing repos.yml. Copying repos.yml.sample to repos.yml. Adjust as necessary and re-reun the last command."
                    FileUtils.cp "#{repos_yml_path}.sample", repos_yml_path
                    abort 
                  end
                  YAML.load_file(repos_yml_path)
                end
      @yaml[:repos]
    end

  private

    def check_for_clean_repos(message)
      unless all_repos_clean?
        puts "*** #{message} ***"
        status
        exit 1
      end
    end
    
    def all_repos_clean?
      repos.all? do |r|
        !File.exist?(r[:path]) ||
        (output = `cd #{r[:path]} && git status`;
         (ENV['IGNORE_BRANCH'].nil? ? output.include?('On branch master') : true) &&
         !output.include?('Changes to be committed:') &&
         !output.include?('Changed but not updated:'))
      end
    end
    
    def url_prefix
      if ENV["COMMITTER"]
        "git@github.com:dchelimsky"
      elsif ENV["REPO_PREFIX"]
        ENV["REPO_PREFIX"]
      else
        "git://github.com/dchelimsky"
      end
    end
  end
end
