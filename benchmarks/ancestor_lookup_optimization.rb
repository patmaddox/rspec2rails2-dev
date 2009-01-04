$:.unshift File.join(File.dirname(__FILE__), "/../example_rails_app/vendor/plugins/rspec/lib")
require 'spec'
require 'benchmark'

Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      10_000.times do
        describe "a" do
          describe "b" do
            describe "c" do
              describe "d" do
                it "does something" do
                  5.should == 5
                end
              end
            end
          end
        end
      end
    end
  end
end
