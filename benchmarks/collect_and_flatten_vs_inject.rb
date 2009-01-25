$:.unshift File.join(File.dirname(__FILE__), "/../example_rails_app/vendor/plugins/rspec/lib")
require 'spec'
require 'benchmark'

n = 100_000

puts %Q{
  a = [[1,2],[3,4],[5,6],[7,8]]
  a.inject([]) do |result, sub|
    result += sub
  end
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        a = [[1,2],[3,4],[5,6],[7,8]]
        a.inject([]) do |result, sub|
          result += sub
        end
      end
    end
  end
end

puts %Q{
  a = [[1,2],[3,4],[5,6],[7,8]]
  a.collect |sub|
    sub
  end.flatten
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        a = [[1,2],[3,4],[5,6],[7,8]]
        a.collect do |sub|
          sub
        end.flatten
      end
    end
  end
end
