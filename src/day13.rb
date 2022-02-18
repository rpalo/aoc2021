require 'set'

module Day13
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day13_test.txt' : 'data/day13.txt'
    dots, instructions = parse(filename)
    dots = Set.new(dots)
    instructions.each do |instruction|
      dots = dots.map { |dot| dot.fold(instruction) }
    end
    display(dots)
  end

  def self.parse(filename)
    text = File.read(filename)
    dots, instructions = text.split("\n\n")
    dots = dots.lines.map do |line|
      x, y = line.split(",").map(&:to_i)
      Point.new(x, y)
    end
    instructions = instructions.lines.map do |line|
      _fold, _along, info = line.split(" ")
      Instruction.new(info[0], info[2..].to_i)
    end
    [dots, instructions]
  end

  Point = Struct.new(:x, :y) do
    def fold(instruction)
      if instruction.axis == "x"
        return Point.new(x, y) if instruction.value >= x
        return Point.new(instruction.value - (x - instruction.value), y)
      else
        return Point.new(x, y) if instruction.value >= y
        return Point.new(x, instruction.value - (y - instruction.value))
      end
    end
  end

  Instruction = Struct.new(:axis, :value)

  def self.display(dots)
    width = dots.map(&:x).max + 1
    height = dots.map(&:y).max + 1
    screen = Array.new(height) { Array.new(width, '.') }
    dots.each { |dot| screen[dot.y][dot.x] = '#' }
    puts screen.map { |line| line.join("") }.join("\n")
  end
end
