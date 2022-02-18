require 'set'

module Day12
  def self.main
    filename = "data/day12" + (ARGV.empty? ? ".txt" : "_#{ARGV[0]}.txt")
    graph = parse(filename)
    paths = routes(graph)
    scenic = scenic_routes(graph)
    puts "There are #{paths.count} simple paths."
    puts "There are #{scenic.count} scenic paths."
  end

  def self.parse(filename)
    graph = {}
    File.open(filename).map do |line|
      a, b = line.chomp.split("-")
      graph[a] = [] unless graph.include?(a)
      graph[b] = [] unless graph.include?(b)
      graph[a] << b
      graph[b] << a
    end
    graph
  end

  def self.routes(graph)
    frontier = [["start"]]
    paths = []
    until frontier.empty?
      current_chain = frontier.shift
      current_node = current_chain[-1]
      graph[current_node].each do |neighbor|
        if neighbor == "end"
          paths << current_chain + ["end"]
          next
        elsif neighbor == neighbor.downcase && current_chain.include?(neighbor)
          next
        else
          frontier << current_chain + [neighbor]
        end
      end
    end

    paths
  end

  class Path
    attr_accessor :double_seen

    def initialize(path, seen=nil, double_seen=nil)
      @path = path
      @seen = seen || Set.new
      @double_seen = double_seen
    end

    def +(node)
      Path.new(@path + [node], @seen.dup, @double_seen)
    end

    def last
      @path[-1]
    end

    def allowed?(node)
      return false if node == "start"
      return true if node == node.upcase
      return true if !@seen.include?(node)
      return true if @double_seen.nil?
      
      false
    end

    def track(node)
      return if node == node.upcase

      if !@seen.include?(node)
        @seen << node
      elsif @double_seen.nil?
        @double_seen = node
      else
        raise "Trying to double-see a second node! #{self}\nNode: #{node}"
      end
    end

    def to_s
      "Path\n@path=#{@path}\n@seen=#{@seen}\n@double_seen=#{@double_seen}"
    end
  end

  def self.scenic_routes(graph)
    frontier = [Path.new(["start"])]
    paths = []
    until frontier.empty?
      current_path = frontier.shift
      current_node = current_path.last
      current_path.track(current_node)
      graph[current_node].each do |neighbor|
        if neighbor == "end"
          paths << current_path + "end"
          next
        elsif current_path.allowed?(neighbor)
          frontier << current_path + neighbor
        end
      end
    end

    paths
  end
end
