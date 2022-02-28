require 'day15'

describe Day15 do
    describe Day15::PriorityQueue do
        it "inserts things in the right order" do
            p = Day15::PriorityQueue.new
            p << 1
            p << 5
            p << 3
            expect(p.to_a).to eq([1, 3, 5])
        end

        it "sorts via a block" do
            p = Day15::PriorityQueue.new(&:length)
            p << "banana"
            p << "peach"
            p << "bug"
            expect(p.to_a).to eq(["bug", "peach", "banana"])
        end
    end
end
