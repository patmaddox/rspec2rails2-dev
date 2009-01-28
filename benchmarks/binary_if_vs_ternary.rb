$:.unshift File.join(File.dirname(__FILE__), "/../example_rails_app/vendor/plugins/rspec/lib")
require 'spec'
require 'benchmark'

n = 10_000_000

puts %Q{
  if true
    'true'
  else
    'false'
  end
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        if true
          'true'
        else
          'false'
        end
      end
    end
  end
end

puts %Q{
  true ? 'true' : 'false'
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        true ? 'true' : 'false'
      end
    end
  end
end
