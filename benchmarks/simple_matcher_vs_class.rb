$:.unshift File.join(File.dirname(__FILE__), "/../example_rails_app/vendor/plugins/rspec/lib")
require 'benchmark'
require 'spec/expectations'
include Spec::Matchers

n = 10_000

puts %Q{
  # using simple_matcher
  5.should equal(5)
  
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        5.should equal(5)
      end
    end
  end
end

puts %Q{
  # using class
  5.should eq(5)
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        5.should eq(5)
      end
    end
  end
end
