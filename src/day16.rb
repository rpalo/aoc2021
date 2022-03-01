module Day16
  def self.main
    filename = ARGV[0] == 'test' ? 'data/day16_test.txt' : 'data/day16.txt'
    bits = parse(filename)
    packet = make_packet(bits)
    puts "Part 1: #{packet.sum_version}"
    puts "Part 2: #{packet.value}"
  end

  def self.parse(filename)
    hex_to_binary(File.read(filename))
  end

  def self.hex_to_binary(str)
    str.chars.map { |c| c.to_i(16).to_s(2).rjust(4, "0").chars }.flatten
  end

  def self.make_packet(bits)
    case bits[3..5]
    when ["1", "0", "0"]
      LiteralPacket.parse(bits)
    else
      OperatorPacket.parse(bits)
    end
  end

  def self.make_packets(bits, subpackets=nil)
    packets = []
    packets << make_packet(bits) until bits.empty? ||
      (!subpackets.nil? && packets.size >= subpackets)
    packets
  end


  class Packet
    attr_reader :version, :type_id

    def initialize(version, type_id)
      @version = version
      @type_id = type_id
    end

    def ==(other)
      @version == other.version && @type_id == other.type_id
    end

    def sum_version
      @version
    end
  end

  class LiteralPacket < Packet
    attr_reader :value

    def initialize(version, type_id, value)
      super(version, type_id)
      @value = value
    end

    def ==(other)
      super(other) && @value == other.value
    end

    def self.parse(bits)
      version = bits.shift(3).join.to_i(2)
      type_id = bits.shift(3).join.to_i(2)
      value = parse_groups(bits)
      self.new(version, type_id, value)
    end

    def self.parse_groups(bits)
      value_bits = []
      loop do
        current = bits.shift(5)
        value_bits << current[1..]
        break if current[0] == "0"
      end
      value = value_bits.flatten.join.to_i(2)
    end
  end

  class OperatorPacket < Packet
    def initialize(version, type_id, length_id, length, packets)
      super(version, type_id)
      @length_id = length_id
      @length = length
      @packets = packets
    end

    def ==(other)
      super(other) && 
      @length_id == other.length_id && 
      @length == other.length &&
      @packets == other.packets
    end

    def sum_version
      super + @packets.sum(&:sum_version)
    end

    def value
      case @type_id
      when 0
        @packets.sum(&:value)
      when 1
        @packets.reduce(1) { |acc, packet| acc * packet.value }
      when 2
        @packets.map(&:value).min
      when 3
        @packets.map(&:value).max
      when 4
        raise "Operator packet with type id 4!"
      when 5
        @packets[0].value > @packets[1].value ? 1 : 0
      when 6
        @packets[0].value < @packets[1].value ? 1 : 0
      when 7
        @packets[0].value == @packets[1].value ? 1 : 0
      else
        raise "Unrecognized type id in operator: #{@type_id}"
      end
    end

    def self.parse(bits)
      version = bits.shift(3).join.to_i(2)
      type_id = bits.shift(3).join.to_i(2)
      length_id = bits.shift
      if length_id == "0"
        length = bits.shift(15).join.to_i(2)
        packets = Day16::make_packets(bits.shift(length))
      elsif length_id == "1"
        length = bits.shift(11).join.to_i(2)
        packets = Day16::make_packets(bits, subpackets=length)
      else
        raise "Unexpected length_id: #{length_id}"
      end
      self.new(version, type_id, length_id, length, packets)
    end
  end
end
