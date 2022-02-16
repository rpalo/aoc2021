require "set"
require "byebug"

module Day8
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day8_test.txt' : 'data/day8.txt'
    entries = parse(filename)
    total = entries.sum { |entry| decode(entry) }
    puts "Total: #{total}"
  end

  # An Entry from the input file (one line) consisting of multiple
  # groups of characters for inputs and 4 groups for outputs.
  # All groups possibly consist of the letters 'a' through 'g'
  class Entry
    attr_reader :inputs, :outputs, :sets

    def initialize(inputs, outputs)
      @inputs = inputs
      @outputs = outputs
      @sets = (inputs + outputs).map { |group| Set.new(group.chars) }
    end

    def get_with_length(n)
      @sets.select { |group| group.length == n }.first
    end
  end

  def self.parse(filename)
    File.open(filename).map do |line|
      inputs, outputs = line.split(" | ")
      Entry.new(inputs.split(" "), outputs.split(" "))
    end
  end

  # Solution to Day 8 Part 1: How many 1's, 4's, 7's, or 8's are there?
  def self.count_easy_outputs(entries)
    entries.sum do |entry|
      entry.outputs.count { |output| [2, 3, 4, 7].include?(output.length) }
    end
  end

  # Solution to Day 8 Part 2: Decode which letters map to which segments
  # I'm using this map to denote segment assignments:
  #  aaaa
  # b    c
  # b    c
  #  dddd
  # e    f
  # e    f
  #  gggg
  # 
  # See below __END__ for algorithm logic
  def self.decode(entry)
    code = {}
    cf = entry.get_with_length(2)
    one = cf
    acf = entry.get_with_length(3)
    seven = acf
    a = acf - cf
    bdcf = entry.get_with_length(4)
    four = bdcf
    bd = bdcf - cf
    eight = entry.get_with_length(7)
    code[eight] = 8
    zero = entry.sets.select { |group| group.length == 6 }
            .select { |group| (group & bd).length == 1 }.first
    d = eight - zero
    b = bd - d
    six = entry.sets.select { |group| group.length == 6 }
            .select { |group| (group & cf).length == 1 }.first
    c = eight - six
    f = cf - c
    nine = entry.sets.select { |group| group.length == 6 }
            .select { |group| group != zero && group != six }.first
    e = eight - nine
    g = eight - (a | b | c | d | e | f)
    two = (a | c | d | e | g)
    three = (a | c | d | f | g)
    five = (a | b | d | f | g)
    code[zero] = 0
    code[one] = 1
    code[two] = 2
    code[three] = 3
    code[four] = 4
    code[five] = 5
    code[six] = 6
    code[seven] = 7
    code[eight] = 8
    code[nine] = 9

    [1000, 100, 10, 1].zip(entry.outputs)
      .sum { |multiplier, group| multiplier * code[Set.new(group.chars)] }
  end
end

__END__

count 2 = 1, cf
count 3 = 7, letter not in 2 is a
count 4 = 4, letters not in 2 are bd
count 7 = 8
count 6 missing either b or d = 0 (missing is d, other is b)
count 6 missing either c or f = 6 (missing is c, other is f)
remaining 6 is 9 (missing is e, present is g)
now we know a, b, c, d, e, f, g
now we know 0, 1, 4, 6, 7, 8, 9
2 is acdeg
3 is acdfg
5 is abdfg
