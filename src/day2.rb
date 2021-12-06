module Day2
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day2_test.txt' : 'data/day2.txt'

    instructions = File.readlines(filename)
    sub = Submarine.new
    sub.process(instructions)
    puts "Depth: #{sub.depth}, Position: #{sub.x}.  Result: #{sub.depth * sub.x}"
    
    sub = AimedSubmarine.new
    sub.process(instructions)
    puts "Depth: #{sub.depth}, Position: #{sub.x}.  Result: #{sub.depth * sub.x}"
  end

  # Follows instructions and tracks its forward progress and depth
  class Submarine
    attr_reader :x, :depth

    def initialize
      @x = 0
      @depth = 0
    end

    def process(instructions)
      instructions.each do |instruction|
        case instruction.split
        in ["forward", x]
          forward(x.to_i)
        in ["up", y]
          dive(-1 * y.to_i)
        in ["down", y]
          dive(y.to_i)
        else
          raise "Unrecognized input: #{instruction}"
        end
      end
    end

    def forward(amount)
      @x += amount
    end

    def dive(amount)
      @depth += amount
    end
  end

  class AimedSubmarine < Submarine
    def initialize
      super
      @aim = 0
    end

    def forward(amount)
      super
      @depth += amount * @aim
    end

    def dive(amount)
      @aim += amount
    end
  end
end
