require 'set'

module Day15
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day15_test.txt' : 'data/day15.txt'
    grid = parse(filename)
    best = best_path(grid, grid.first.first, grid.last.last)
    puts "Lowest Risk: #{best.risk}"
    puts best
  end

  Point = Struct.new(:risk, :x, :y, :neighbors) do 
    def manhattan_dist(other)
      (x - other.x).abs + (y - other.y).abs
    end

    def to_s
      "(#{x}, #{y})"
    end
  end

  def self.parse(filename)
    grid = File.read(filename).split("\n").map.with_index do |line, y|
      line.chars.map.with_index do |c, x|
        Point.new(c.to_i, x, y, [])
      end
    end

    sample_height = grid.size
    raise "Empty grid." if sample_height.zero?

    sample_width = grid[0].size
    raise "Zero-width grid." if sample_width.zero?

    (1..4).each do |i|
      grid.each do |row|
        (0...sample_width).each do |x|
          point = Point.new(row[x].risk + i, (1 + i) * sample_width + x, row[x].y, [])
          point.risk = point.risk - 9 if point.risk > 9
          row << point
        end
      end
    end

    (1..4).each do |j|
      new_rows = []
      grid[0...sample_height].each do |row|
        new_rows << []
        row.each do |point|
          new_rows.last << Point.new(point.risk + j, point.x, (j + 1) * sample_height + point.y, [])
          new_rows.last.last.risk -= 9 if new_rows.last.last.risk > 9
        end
      end
      grid += new_rows
    end

    height = sample_height * 5
    width = sample_width * 5

    grid.each_with_index do |row, y|
      row.each_with_index do |point, x|
        # point.neighbors << grid[y - 1][x] if y > 0
        point.neighbors << grid[y + 1][x] if y < height - 1
        # point.neighbors << grid[y][x - 1] if x > 0
        point.neighbors << grid[y][x + 1] if x < width - 1
      end
    end

    grid
  end


  class Path
    attr_reader :heuristic

    def initialize(path, goal)
      @path = path
      @goal = goal
      @heuristic = risk  # + @path.last.manhattan_dist(goal)
    end

    def children
      @path.last.neighbors.map do |neighbor|
        Path.new(@path + [neighbor], @goal)
      end
    end

    def risk
      @path[1..].sum(&:risk)
    end

    def last
      @path.last
    end

    def to_s
      @path.map(&:risk).join(", ")
    end
  end

  class PriorityQueue
    def initialize(&block)
      @list = []
      @func = block || -> (i) { i.itself }
    end
    
    def <<(item)
      if @list.empty?
        @list << item
        return self
      end

      index = @list.bsearch_index { |el| @func.(el) >= @func.(item) }
      index = -1 if index.nil?
      @list.insert(index, item)
      
      self
    end

    def shift
      @list.shift
    end

    def to_s
      @list.map(&@func).join(", ")
    end

    def empty?
      @list.empty?
    end

    def to_a
      @list.dup
    end
  end


  def self.best_path(grid, start, goal)
    frontier = PriorityQueue.new(&:heuristic)
    frontier << Path.new([start], goal)
    closest = start.manhattan_dist(goal)
    seen = Set.new
    until frontier.empty?
      current = frontier.shift
      if current.last == goal
        return current
      end
      seen << [current.last.x, current.last.y]
      if (distance = current.last.manhattan_dist(goal)) < closest
        puts distance
        closest = distance
      end
      current.children.each do |child|
        unless seen.include?([child.last.x, child.last.y])
          frontier << child
        end
      end
    end

    raise "Couldn't find a path to the goal."
  end

  def self.display_grid(grid)
    puts (grid.map do |row|
      row.map do |point|
        point.risk
      end.join
    end.join("\n"))
  end
end
