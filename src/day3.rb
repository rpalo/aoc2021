module Day3
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day3_test.txt' : 'data/day3.txt'

    diag = Diagnostic.new(File.readlines(filename, chomp: true))
    puts "Power Consumed: #{diag.power_consumption}"
    puts "Life Support: #{diag.life_support_rating}"
  end

  class Diagnostic
    def initialize(values)
      @values = values.map(&:chars)
      @count = values.count
      @gamma_bits = []
      @epsilon_bits = []
      get_common_bits
    end

    def get_common_bits
      @values[0].zip(*@values[1..])
                .map { |place_digits| place_digits.count('1') }
                .each do |s|
                  if s > (@count / 2)
                    @gamma_bits << '1'
                    @epsilon_bits << '0'
                  else
                    @gamma_bits << '0'
                    @epsilon_bits << '1'
                  end
                end
    end

    def gamma_rate
      @gamma_bits.join.to_i(2)
    end

    def epsilon_rate
      @epsilon_bits.join.to_i(2)
    end

    def power_consumption
      gamma_rate * epsilon_rate
    end

    def generic_rating(&comp)
      keeps = @values
      0.upto(@count) do |i|
        ones = keeps.map { |digits| digits[i] }.count { |i| i == '1' }
        pass = comp.call(ones, keeps.count.to_f / 2) ? '1' : '0'
        keeps = keeps.filter { |digits| digits[i] == pass }

        return keeps[0].join.to_i(2) if keeps.count == 1
      end
      raise "Couldn't find it."
    end

    def oxygen_generator_rating
      generic_rating(&:>=)
    end

    def co2_scrubber_rating
      generic_rating(&:<)
    end

    def life_support_rating
      oxygen_generator_rating * co2_scrubber_rating
    end
  end
end
