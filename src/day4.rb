require 'set'

module Day4
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day4_test.txt' : 'data/day4.txt'
    File.open(filename) do |f|
      numbers = f.readline.split(',').map(&:to_i)
      f.readline
      boards = f.read.split("\n\n").map do |text|
        rows = text.split("\n").map { |line| line.split.map(&:to_i) }
        BingoBoard.new(rows)
      end
      
      winning_score = play_to_lose(numbers, boards)
      if winning_score.nil?
        puts "No winner found."
      else
        puts winning_score
      end
    end
  end

  def self.play(numbers, boards)
    numbers.each do |number|
      boards.each do |board|
        board.mark(number)
        return board.score * number if board.won?
      end
    end

    nil
  end

  def self.play_to_lose(numbers, boards)
    next_boards = []
    numbers.each do |number|
      boards.each do |board|
        board.mark(number)
        next_boards << board unless board.won?
        return board.score * number if boards.size == 1 && board.won?
      end

      boards = next_boards
      next_boards = []
    end

    nil
  end

  # A 5x5 board with 1- or 2-digit positive integers for bingo.
  # Only all 5 in a row or all 5 in a column can win.  No diagonals
  class BingoBoard
    def initialize(rows)
      @numbers = {}
      rows.each_with_index do |row, y|
        row.each_with_index do |number, x|
          @numbers[number] = [x, y]
        end
      end
      @seen = Set.new
      @hits = {
        x: [0, 0, 0, 0, 0],
        y: [0, 0, 0, 0, 0]
      }
    end

    def mark(number)
      return false unless @numbers.include?(number)

      x, y = @numbers[number]
      @seen.add(number)
      @hits[:x][x] += 1
      @hits[:y][y] += 1
      true
    end

    def won?
      @hits.values.any? do |axis|
        axis.any? { |group| group == 5 }
      end
    end

    def score
      @numbers.keys.sum - @seen.sum
    end
  end
end
