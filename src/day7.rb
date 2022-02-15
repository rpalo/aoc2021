module Day7

  def self.main
    filename = ARGV[0] == 'test' ? 'data/day7_test.txt' : 'data/day7.txt'
    positions = parse(filename)
    
    puts "The minimum fuel cost is: #{optimize_crabs(positions)}."
  end

  def self.parse(filename)
    File.read(filename).split(",").map(&:to_i)
  end

  def self.optimize_crabs(positions)
    best_position = (positions.min..positions.max).min_by do |index|
      positions.sum { |position| crab_cost((position - index).abs) }
    end
    spent_fuel = positions.sum { |position| crab_cost((position - best_position).abs) }
    spent_fuel
  end

  def self.crab_cost(delta)
    delta.zero? ? 0 : (1..delta).reduce(&:+)
  end
end
