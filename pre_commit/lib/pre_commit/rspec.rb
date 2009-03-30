class PreCommit::Rspec < PreCommit
  def pre_commit
    # check_for_gem_dependencies
    fix_cr_lf
    touch_revision_storing_files
    pre_commit_core
    pre_commit_textmate_bundle
    pre_commit_rails
    ok_to_commit
  end
  
  def check_for_gem_dependencies
    require "rubygems"
    gem 'rake'
    gem 'syntax'
    gem 'diff-lcs'
    gem 'mocha'
    gem 'flexmock'
    gem 'rr'

    if RUBY_VERSION =~ /^1.8/
      gem 'webby'
      gem 'coderay'
      gem 'RedCloth'
      gem 'heckle' unless RUBY_PLATFORM == "i386-mswin32"
      gem 'nokogiri'
    end
  end

  def fix_cr_lf
    files = FileList['**/*.rb'].
            exclude('example_rails_app/vendor/**').
            exclude('rspec/translated_specs/**')
    $\="\n"
    files.each do |f|
      raw_content = File.read(f)
      fixed_content = ""
      raw_content.each_line do |line|
        fixed_content << line
      end
      unless raw_content == fixed_content
        File.open(f, "w") do |io|
          io.print fixed_content
        end
      end
    end
  end
  
  def touch_revision_storing_files
    files = [
      "rspec/lib/spec/version.rb",
      "rspec-rails/lib/spec/rails/version.rb"
    ]
    build_time_utc = Time.now.utc.strftime('%Y%m%d%H%M%S')
    files.each do |path|
      abs_path = File.join(RSPEC_PLUGIN_ROOT, path)
      content = File.open(abs_path).read
      touched_content = content.gsub(/BUILD_TIME_UTC = (\d*)/, "BUILD_TIME_UTC = #{build_time_utc}")
      File.open(abs_path, 'w') do |io|
        io.write touched_content
      end
    end
  end
  
  def pre_commit_core
    Dir.chdir "#{RSPEC_PLUGIN_ROOT}/rspec" do
      rake = (RUBY_PLATFORM == "i386-mswin32") ? "rake.bat" : "rake"
      system("#{rake} --verbose --trace")
      raise "RSpec Core pre_commit failed" if error_code?
    end    
  end

  def pre_commit_textmate_bundle
    Dir.chdir "#{RSPEC_DEV_ROOT}/RSpec.tmbundle/Support" do
      rake = (RUBY_PLATFORM == "i386-mswin32") ? "rake.bat" : "rake"
      system("#{rake} spec --verbose --trace")
      raise "RSpec Textmate Bundle specs failed" if error_code?
    end    
  end

  def install_dependencies
    Dir.chdir "#{RSPEC_DEV_ROOT}/example_rails_app" do
      rake_sh("-f Multirails.rake install_dependencies")
    end
  end

  def update_dependencies
    Dir.chdir "#{RSPEC_DEV_ROOT}/example_rails_app" do
      rake_sh("-f Multirails.rake update_dependencies")
    end
  end

  def pre_commit_rails
    Dir.chdir "#{RSPEC_DEV_ROOT}/example_rails_app" do
      rake = (RUBY_PLATFORM == "i386-mswin32") ? "rake.cmd" : "rake"
      cmd = "#{rake} -f Multirails.rake pre_commit --trace"
      system(cmd)
      if error_code?
        message = <<-EOF
        ############################################################
        RSpec on Rails Plugin pre_commit failed. For more info:

          cd example_rails_app
          #{cmd}

        ############################################################
        EOF
        raise message.gsub(/^        /, '')
      end
    end
  end
  
  def ok_to_commit
    puts "OK TO COMMIT"
  end
end
