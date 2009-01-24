$:.unshift File.join(File.dirname(__FILE__), "/../example_rails_app/vendor/plugins/rspec/lib")
require 'spec'
require 'benchmark'

n = 100_000

puts %Q{
  h = {}
  (1..#{n}).each do |x|
    h['a'] && h['a']['b']
  end
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      h = {}
      (1..n).each do |x|
        h['a'] && h['a']['b']
      end
    end
  end
end

puts %Q{
  h = Hash.new {|h,k| h[k] = {}}
  (1..#{n}).each do |a|
    h['a']['b']
  end
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      h = Hash.new {|h,k| h[k] = {}}
      (1..n).each do |x|
        h['a']['b']
      end
    end
  end
end

puts %Q{
  h = Hash.new {|h,k| h[k] = {}}
  (1..#{n}).each do |x|
    h[x]['b']
  end
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      h = Hash.new {|h,k| h[k] = {}}
      (1..n).each do |x|
        h[x]['b']
      end
    end
  end
end
