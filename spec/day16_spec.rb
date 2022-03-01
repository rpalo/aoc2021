require 'day16'

describe Day16 do
  describe "parsing" do
    it "parses hex to binary string chars" do
      expect(Day16::hex_to_binary("D2FE28")).to eq "110100101111111000101000".chars
    end

    it "reads a value packet properly" do
      expect(Day16::LiteralPacket::parse_groups("101111111000101000".chars)).to eq 2021
    end

    it "recognizes and creates a LiteralPacket" do
      bits = "110100101111111000101000".chars
      expected = Day16::LiteralPacket.new(6, 4, 2021)
      expect(Day16::make_packet(bits)).to eq expected
    end
  end

  describe "Part 1" do
    it "adds up version numbers" do
      packet = Day16::make_packet(Day16::hex_to_binary("8A004A801A8002F478"))
      expect(packet.sum_version).to eq 16
    end

    it "adds up more version numbers" do
      packet = Day16::make_packet(Day16::hex_to_binary("620080001611562C8802118E34"))
      expect(packet.sum_version).to eq 12
    end

    it "adds up even more version numbers" do
      packet = Day16::make_packet(Day16::hex_to_binary("C0015000016115A2E0802F182340"))
      expect(packet.sum_version).to eq 23
    end

    it "adds up even more version numbers pt 2" do
      packet = Day16::make_packet(Day16::hex_to_binary("A0016C880162017C3686B18A3D4780"))
      expect(packet.sum_version).to eq 31
    end
  end

  describe "Part 2" do
    it "computes a sum" do
      packet = Day16::make_packet(Day16::hex_to_binary("C200B40A82"))
      expect(packet.value).to eq 3
    end

    it "computes a product" do
      packet = Day16::make_packet(Day16::hex_to_binary("04005AC33890"))
      expect(packet.value).to eq 54
    end

    it "computes a minimum of 3 values" do
      packet = Day16::make_packet(Day16::hex_to_binary("880086C3E88112"))
      expect(packet.value).to eq 7
    end

    it "computes a maximum of 3 values" do
      packet = Day16::make_packet(Day16::hex_to_binary("CE00C43D881120"))
      expect(packet.value).to eq 9
    end

    it "computes a less than" do
      packet = Day16::make_packet(Day16::hex_to_binary("D8005AC2A8F0"))
      expect(packet.value).to eq 1
    end

    it "computes a greater than" do
      packet = Day16::make_packet(Day16::hex_to_binary("F600BC2D8F"))
      expect(packet.value).to eq 0
    end

    it "computes a equality" do
      packet = Day16::make_packet(Day16::hex_to_binary("9C005AC2F8F0"))
      expect(packet.value).to eq 0
    end

    it "computes a complicated equation 1 + 3 = 2 * 2" do
      packet = Day16::make_packet(Day16::hex_to_binary("9C0141080250320F1802104A08"))
      expect(packet.value).to eq 1
    end
  end
end
