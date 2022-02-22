require 'set'

module Day14
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day14_test.txt' : 'data/day14.txt'
    start, rules = parse(filename)
    pair_counts = compact_insert(rules, start, 40)
    char_counts = sum_pairs(pair_counts)
    occurrences = char_counts.values.sort
    puts occurrences[-1] - occurrences[0]
  end

  def self.parse(filename)
    lines = File.readlines(filename, chomp: true)
    start = lines.first
    rules = lines[2..].map { |line| line.split(" -> ") }.to_h
    [start, rules]
  end

  def self.compact_insert(rules, s, steps)
    all_letters = Set.new(rules.keys.map(&:chars).flatten)
    all_pairs = all_letters.to_a.repeated_permutation(2)
    counts = all_pairs.map { |pair| [pair.join, 0] }.to_h
    s.chars.each_cons(2).each { |pair| counts[pair.join] += 1 }

    steps.times do
      new_counts = counts.dup
      counts.each do |pair, qty|
        new_char = rules[pair]
        new_counts["#{pair[0]}#{new_char}"] += qty
        new_counts["#{new_char}#{pair[1]}"] += qty
        new_counts[pair] -= qty
      end
      counts = new_counts
    end
    counts
  end

  def self.sum_pairs(pair_counts)
    char_counts = Hash.new(0)
    pair_counts.each do |pair, count|
      char_counts[pair[0]] += count
      char_counts[pair[1]] += count
    end
    char_counts.map do |char, count|
      if count.odd?
        [char, count/2 + 1]
      else
        [char, count/2]
      end
    end.to_h
  end

  # Naive try:

  def self.find_insertions(rule, s)
    (0...s.length-1).find_all { |i| s[i, 2] == rule }.map { |index| index + 1 }
  end

  def self.insert(rules, s)
    actions = rules.map do |pattern, char|
      insertion_points = find_insertions(pattern, s)
      insertion_points.map { |ip| [char, ip] }
    end.flatten(1).sort_by(&:last)
    new_string = s.chars
    offset = 0
    actions.each do |char, index|
      new_string.insert(index + offset, char)
      offset += 1
    end
    new_string.join
  end
end
