require 'day10'

describe Day10 do
  describe "check_syntax" do
    it "finds a mistaken closer" do
      line = "{([(<{}[<>[]}>{[]{[(<()>"
      error = Day10::check_syntax(line)
      expect(error).to eq '}'
    end

    it "finds a second mistaken closer" do
      line = "[[<[([]))<([[{}[[()]]]"
      error = Day10::check_syntax(line)
      expect(error).to eq ')'
    end
  end
end
