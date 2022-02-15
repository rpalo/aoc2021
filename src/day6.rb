module Day6
  G_PERIOD = 6
  NEWBORN_G_PERIOD = 8

  def self.main
    filename = ARGV[0] == 'test' ? 'data/day6_test.txt' : 'data/day6.txt'
    fishes = parse(filename)
    days = 256
    puts "There are #{breed_lanternfish(fishes, days)} lanternfish after #{days} days."
  end

  def self.parse(filename)
    File.read(filename).split(",").map(&:to_i)
  end

  def self.breed_lanternfish(initial_fishes, days)
    ready_adults = Array.new(days + 9, 0)
    initial_fishes.each do |fish|
      ready_adults[fish] += 1
    end
    count = initial_fishes.count
    (0...days).each do |t|
      ready_adults[t + 7] += ready_adults[t]
      ready_adults[t + 9] += ready_adults[t]
      count += ready_adults[t]
    end
    count
  end
end
