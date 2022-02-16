require 'day8'

describe Day8 do
  describe "decode" do
    it "decodes an entry" do
      entry = Day8::Entry.new(
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab".split(" "),
        "cdfeb fcadb cdfeb cdbaf".split(" ")
      )
      output = Day8.decode(entry)
      expect(output).to eq(5353)
    end
  end
end
