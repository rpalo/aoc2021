require 'set'


module Day5
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day5_test.txt' : 'data/day5.txt'
    lines = parse(filename)
    intersections = find_intersections(lines)
    puts "#{intersections.size} points of overlap"
  end
  
  def self.parse(filename)
    File.readlines(filename).map do |line|
      p1, p2 = line.split(' -> ')
      x1, y1 = p1.split(',').map(&:to_i)
      x2, y2 = p2.split(',').map(&:to_i)
      NaiveLine.new(x1, y1, x2, y2)
    end
  end
  
  def self.find_intersections(lines)
    intersections = Hash.new(0)
    lines.combination(2) do |a, b|
      a.intersections(b).each { |point| intersections[point] += 1 }
    end
    intersections
  end
  
  Point = Struct.new(:x, :y)
  
  class OverlappingRange < Range
    def self.proper(a, b)
      a < b ? self.new(a, b) : self.new(b, a)
    end

    def overlap?(other)
      (first <= other.first && last >= other.first) ||
        (last >= other.last && first <= other.last)
    end

    def &(other)
      OverlappingRange.new([first, other.first].max, [last, other.last].min)
    end
  end
  
  # I don't love this, but it works!
  class NaiveLine
    def initialize(x1, y1, x2, y2)
      @first = Point.new(x1, y1)
      @last = Point.new(x2, y2)
      @x_step = if x1 < x2
                  1
                elsif x1 == x2
                  0
                else
                  -1
                end
      @y_step = if y1 < y2
                  1
                elsif y1 == y2
                  0
                else
                  -1
                end
      @count = [(x2 - x1).abs, (y2 - y1).abs].max
    end
    
    def intersections(other)
      Set.new(points) & Set.new(other.points)
    end

    def points
      0.upto(@count).map do |i|
        Point.new(@first.x + @x_step * i, @first.y + @y_step * i)
      end
    end
  end
end


# class Line
#   attr_reader :type, :span, :fixed

#   def initialize(x1, y1, x2, y2)
#     if x1 == x2
#       @type = :vertical
#       @span = OverlappingRange.proper(y1, y2)
#       @fixed = x1
#     elsif y1 == y2
#       @type = :horizontal
#       @span = OverlappingRange.proper(x1, x2)
#       @fixed = y1
#     else
#       @type = :diagonal
#     end
#   end

#   def intersections(other)
#     if @type == :vertical && other.type == :horizontal
#       if @span.include?(other.fixed) && other.span.include?(@fixed)
#         return [Point.new(@fixed, other.fixed)]
#       end
#     elsif @type == :horizontal && other.type == :vertical
#       if @span.include?(other.fixed) && other.span.include?(@fixed)
#         return [Point.new(other.fixed, @fixed)]
#       end
#     elsif @type == :vertical && @fixed == other.fixed
#       return (@span & other.span).map { |y| Point.new(@fixed, y) }
#     elsif @type == :horizontal && @fixed == other.fixed
#       return (@span & other.span).map { |x| Point.new(x, @fixed) }
#     end
#     []
#   end
# end