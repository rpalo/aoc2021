module Day11
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day11_test.txt' : 'data/day11.txt'
    counter = Counter.new
    grid = Grid.new(parse(filename))
    puts grid.synchronize
  end

  def self.parse(filename)
    File.read(filename).split("\n")
  end

  class Counter
    def initialize
      @count = 0
    end

    def inc
      @count += 1
    end

    def to_s
      "#{@count}"
    end
  end

  class Point
    attr_accessor :energy, :x, :y, :flashed, :neighbors

    def initialize(energy, x, y, counter=nil)
      @energy = energy
      @x = x
      @y = y
      @counter = counter
      @flashed = false
      @neighbors = []
    end

    def flash
      return if @flashed
      @flashed = true
      @counter.inc unless @counter.nil?
      @energy = 0
      @neighbors.each do |neighbor|
        next if neighbor.flashed
        neighbor.energy += 1
        neighbor.flash if neighbor.energy > 9
      end
    end
  end

  class Grid
    def initialize(rows, counter=nil)
      @points = rows.map.with_index do |row, y|
        row.chars.map.with_index do |c, x|
          Point.new(c.to_i, x, y, counter)
        end
      end
      

      height = @points.size
      raise "Empty grid." if height.zero?

      width = @points[0].size
      raise "Zero-width grid." if width.zero?

      @points.each_with_index do |row, y|
        row.each_with_index do |point, x|
          point.neighbors << @points[y - 1][x] if y > 0
          point.neighbors << @points[y + 1][x] if y < height - 1
          point.neighbors << @points[y][x - 1] if x > 0
          point.neighbors << @points[y][x + 1] if x < width - 1
          point.neighbors << @points[y - 1][x - 1] if y > 0 && x > 0
          point.neighbors << @points[y - 1][x + 1] if y > 0 && x < width - 1
          point.neighbors << @points[y + 1][x - 1] if y < height - 1 && x > 0
          point.neighbors << @points[y + 1][x + 1] if y < height - 1 && x < width - 1
        end
      end
    end

    def step
      @points.flatten.each { |p| p.energy += 1 }
      @points.flatten.select { |p| p.energy > 9 }.each { |p| p.flash }
      @points.flatten.each { |p| p.flashed = false }
    end

    def synchronize
      t = 0
      loop do
        t += 1
        @points.flatten.each { |p| p.energy += 1 }
        @points.flatten.select { |p| p.energy > 9 }.each { |p| p.flash }
        return t if @points.flatten.all?(&:flashed)
        @points.flatten.each { |p| p.flashed = false }
      end
    end
  end
end
