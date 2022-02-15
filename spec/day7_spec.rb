require 'day7'

describe Day7 do
  describe "crab_cost" do
    it "should add 1 for each additional step" do
      expect(Day7.crab_cost(6)).to eq(6 + 5 + 4 + 3 + 2 + 1)
    end
  end
end