$:.unshift File.join(File.dirname(__FILE__), "/../example_rails_app/vendor/plugins/rspec/lib")
require 'spec'
require 'benchmark'

n = 1_000_000

puts %Q{
  case 3
  when > 2
    1
  else
    2
  end
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        case 3
        when 2
          1
        else
          2
        end
      end
    end
  end
end

puts %Q{
  3 > 2 ? 1 : 2
  
}
Benchmark.benchmark do |bm|
  4.times do
    bm.report do
      n.times do
        3 > 2 ? 1 : 2
      end
    end
  end
end
