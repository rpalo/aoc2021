module Day10
  OPENERS = "([{<".chars.freeze
  CLOSERS = ")]}>".chars.freeze
  PAIRS = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }.freeze
  SYNTAX_SCORES = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
  }.freeze
  AUTOCOMPLETE_SCORES = {
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4
  }.freeze

  def self.main
    filename = ARGV[0] == 'test' ? 'data/day10_test.txt' : 'data/day10.txt'
    lines = parse(filename)
    auto_scores = lines.map { |line| check_syntax(line) }
                       .select { |status| status.type == :incomplete }
                       .map { |status| autocomplete_score(status.autocomplete) }

    puts auto_scores.sort[auto_scores.length / 2]
  end

  def self.parse(filename)
    File.readlines(filename, chomp: true)
  end

  SyntaxStatus = Struct.new(:type, :error, :autocomplete, keyword_init: true)
  SYNTAX_STATUS_TYPES = [:ok, :corrupt, :incomplete]

  def self.check_syntax(text)
    stack = []
    text.chars.each do |c|
      if OPENERS.include?(c)
        stack.push(c)
      elsif CLOSERS.include?(c)
        if PAIRS[stack.last] == c
          stack.pop
        else
          return SyntaxStatus.new(type: :corrupt, error: c)
        end
      else
        raise "Unexpected character '#{c}'."
      end
    end

    return SyntaxStatus.new(type: :incomplete, autocomplete: stack) unless stack.empty?
    
    SyntaxStatus.new(type: :ok)
  end

  def self.autocomplete_score(stack)
    stack.reverse.reduce(0) do |total, c|
      total *= 5
      total + AUTOCOMPLETE_SCORES[c]
    end
  end
end
