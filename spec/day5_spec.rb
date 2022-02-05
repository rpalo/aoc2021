require 'day5'


describe Day5::Line do
  it "shouldn't overlap if colinear lines don't touch" do
    a = Day5::Line.new(1, 5, 5, 5)
    b = Day5::Line.new(6, 5, 10, 5)
    expect(a.intersections(b)).to be_empty
  end

  it "should overlap on endpoint" do
    a = Day5::Line.new(1, 5, 5, 5)
    b = Day5::Line.new(5, 5, 10, 5)
    expect(a.intersections(b)).not_to be_empty
  end
end

