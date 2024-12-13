class Object
  def clone
    Marshal.load(Marshal.dump(self))
  end
end

class Map < Array

  DIRECTION = [
    [-1,0],
    [0,1],
    [1,0],
    [0,-1],
  ]
  NSEW = {
    [1,0] => :N,
    [-1,0] => :S,
    [0,1] => :E,
    [0,-1] => :W,
  }

  def initialize(map)
    # @map = Marshal.load(Marshal.dump(map))
    @map = map
  end

  def print
    puts '========='
    @map.each do
      puts _1.join('')
    end
  end

  def [](x, y)
    return nil if x < 0 || y < 0
    @map.dig(x,y)
  end

  def []=(x, y, value)
    return nil if x < 0 || y < 0
    @map[x][y] = value
  end

  def foreigns(x,y)
    DIRECTION.map do |(a,b)|
      self[x+a,y+b]
    end
  end

  def explore(x,y, crop, price: {size: 0, fences: []}, hv: nil)
    if self[x,y] == crop
      price[:size] += 1
      self[x,y] = self[x,y].downcase
      DIRECTION.map do |(a,b)|
        hv = NSEW[[a,b]]
        explore(x+a,y+b, crop, price:, hv: )
      end
    elsif self[x,y] != crop && self[x,y] != crop.downcase
      price[:fences] << { pos: [x, y], hv: }
    end
    price
  end
end



grid   = ARGF.readlines(chomp:true).map(&:chars)
map    = Map.new(grid)

sum = 0

def match(a,b)
  (a[0] == b[0] && (a[1] - b[1]).abs == 1) ||
  (a[1] == b[1] && (a[0] - b[0]).abs == 1)
end
def neighbores(a, fences)
  neigh = fences.select { |fence| a[:hv] == fence[:hv] && match(a[:pos], fence[:pos])}
  if neigh
    [a] << (neigh.map do |n|
      neighbores(n, fences-neigh)
    end)
  else
    [a]
  end
end

def compact_fences(fences)
  sections = []
  while !fences.empty?

    fence = fences.first
    section = neighbores(fence, fences - [fence]).flatten
    sections << section

    # puts "fences #{fences.to_s}"
    # puts "section #{section.to_s}"
    fences -= section
    # puts "fences #{fences.to_s}"
  end
  # puts sections.to_s
  sections
end

grid.each.with_index do |lines, row|
  lines.each.with_index do |crop, coll|
    if map[row,coll] != map[row,coll].downcase
      puts '---'
      puts crop
      # puts "Explore: #{map[row,coll]}"
      price = Map.new(grid).explore(row, coll, crop)
      # puts "#{price.to_s}"

      fences = compact_fences(price[:fences])
      count = fences.count

      puts fences.to_s
      puts " #{price[:size]} * #{count} = #{price[:size] * (count)}"
      sum += price[:size] * (count)
      puts sum
    end
  end
end

puts sum
