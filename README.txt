= rspec-dev

* http://rspec.info
* http://github.com/dchelimsky/rspec-dev/wikis
* mailto:rspec-devel@rubyforge.org

== DESCRIPTION:

This project is for RSpec-1 developers/contributors.

NOTE: For RSpec-2, see http://github.com/rspec/rspec-dev

== INSTALL:

  git clone git://github.com/dchelimsky/rspec-dev.git
  cd rspec-dev
  cp repos.yml.sample repos.yml

Take a look at repos.yml, which is used to configure all of the other git
repositories that you'll need to do rspec-rails development. The sample file
is configured to point to public github urls for each repository. If you have
forks of any of the repos, or if you are an rspec core committer, change the
urls accordingly so that you'll be able to seamlessly push to github.

Once that's confifigured:

  rake git:update

== RUNNING SPECS:

In order to run RSpec's full suite of specs (rake pre_commit) you must install
the following gems:

* cucumber  # BDD framework for automating scenarios
* diff-lcs  # Required if you use the --diff switch
* flexmock  # Mocking/stubbing framework
* heckle    # Required if you use the --heckle switch
* hoe       # Required in order to make releases at RubyForge
* mocha     # Mocking/stubbing framework
* nokogiri  # Used for parsing HTML from the HTML output formatter in RSpec's own specs
* rake      # Runs the build script
* rcov      # Verifies that the code is 100% covered by specs
* rr        # Mocking/stubbing framework

If you're on windows, you'll also need:

* win32console  # Required by the --colour switch if you're on Windows

You can easily install all gems by using geminstaller.

  sudo gem install geminstaller
  cd /path/to/rspec-dev
  sudo geminstaller

Once those are all installed, you should be able to run the suite with the following steps:

  cd /path/to/rspec-dev
  cd example_rails_app
  export RSPEC_RAILS_VERSION=2.3.2
  rake rspec:generate_sqlite3_config
  cd ..
  rake pre_commit
  
The rake pre_commit command runs all the specs and cucumber scenarios for
rspec, and then for rspec-rails. The rspec-rails specs are run against all of
the supported versions of rails defined in
pre_commit/lib/pre_commit/rspec-rails.rb, near the top.

Note that RSpec itself - once built - doesn't have any dependencies outside
the Ruby core and stdlib - with a few exceptions:

* The spec command line uses diff-lcs when --diff is specified.
* The spec command line uses heckle when --heckle is specified.
* The Spec::Rake::SpecTask needs RCov if RCov is enabled in the task.

== LICENSE:

(The MIT License)

Copyright (c) 2005-2008 The RSpec Development Team

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
