require 'set'

module Day9
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day9_test.txt' : 'data/day9.txt'
    grid = parse(filename)
    min_points = minima(grid)
    
    puts "Basin score: #{basin_score(min_points)}"
  end

  Point = Struct.new(:height, :x, :y, :neighbors)

  def self.parse(filename)
    grid = File.read(filename).split("\n").map.with_index do |line, y|
      line.chars.map.with_index do |c, x|
        Point.new(c.to_i, x, y, [])
      end
    end

    height = grid.size
    raise "Empty grid." if height.zero?

    width = grid[0].size
    raise "Zero-width grid." if width.zero?

    grid.each_with_index do |row, y|
      row.each_with_index do |point, x|
        point.neighbors << grid[y - 1][x] if y > 0
        point.neighbors << grid[y + 1][x] if y < height - 1
        point.neighbors << grid[y][x - 1] if x > 0
        point.neighbors << grid[y][x + 1] if x < width - 1
      end
    end

    grid
  end

  def self.minima(grid)
    grid.flatten.select do |point|
      point.neighbors.all? { |neighbor| neighbor.height > point.height }
    end
  end

  def self.risk_total(points)
    points.map { |point| 1 + point.height }.sum
  end

  def self.flood(point)
    frontier = [point]
    seen = Set.new
    until frontier.empty?
      current = frontier.shift
      seen << current
      current.neighbors.each do |neighbor|
        next if seen.include?(neighbor)
        next if neighbor.height == 9
        frontier << neighbor
      end
    end
    seen
  end

  def self.basins(points)
    points.map { |point| flood(point) }
  end

  def self.basin_score(points)
    basins(points).map(&:size).sort.reverse.first(3).reduce(&:*)
  end
end
