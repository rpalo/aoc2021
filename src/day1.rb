module Day1
  # Pings the depth in front of the submarine
  class Sonar
    def initialize(depths)
      @depths = depths
    end

    def increases
      @depths.each_cons(2).filter {|a, b| b > a }.count
    end

    def sliding_increases
      @depths.each_cons(3).each_cons(2).filter {|a, b| b.sum > a.sum }.count
    end
  end

  def self.main
    depths = File.readlines("data/#{ARGV[0]}.txt").map(&:to_i)

    sonar = Sonar.new(depths)
    puts "Normal: #{sonar.increases}"
    puts "Sliding: #{sonar.sliding_increases}"
  end
end