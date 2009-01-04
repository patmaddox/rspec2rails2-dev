$:.unshift File.join(File.dirname(__FILE__), "/../example_rails_app/vendor/plugins/rspec/lib")
require 'spec'
require 'benchmark'

Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      1000.times do
        describe "a" do
          before(:each) do
            @a = 1
          end
          describe "b" do
            before(:each) do
              @b = 2
            end
            describe "c" do
              before(:each) do
                @c = 3
              end
              describe "d" do
                before(:each) do
                  @d = 4
                end
                it "does something" do
                  [@a, @b, @c, @d].inject(0) {|sum,n| sum += n}.should == 10
                end
              end
            end
          end
        end
      end
    end
  end
end
