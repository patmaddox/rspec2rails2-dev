$:.unshift File.join(File.dirname(__FILE__), "/../example_rails_app/vendor/plugins/rspec/lib")
require 'benchmark'
require 'spec/expectations'
include Spec::Matchers

n = 100_000

module StringHelpers
  def starts_with?(prefix)
    to_s[0..(prefix.to_s.length - 1)] == prefix.to_s
  end
end

class String
  include StringHelpers
end

class Symbol
  include StringHelpers
end

puts %Q{
  :this.starts_with?("th")
  "this".starts_with?("th")
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        :this.starts_with?("th")
        "this".starts_with?("th")
      end
    end
  end
end

puts %Q{
  :this.to_s =~ /^th/
  "this" =~ /^th/
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        :this.to_s =~ /^th/
        "this" =~ /^th/
      end
    end
  end
end
