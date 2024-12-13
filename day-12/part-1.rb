
class Map < Array

  DIRECTION = [
     [-1,0],
     [0,1],
     [1,0],
     [0,-1],
  ]

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

  def explore(x,y, crop, price: {size: 0, fences: 0})
    if self[x,y] == crop
      price[:size] += 1
      self[x,y] = self[x,y].downcase
      DIRECTION.map do |(a,b)|
        explore(x+a,y+b, crop, price: )
      end
    elsif self[x,y] != crop && self[x,y] != crop.downcase
      price[:fences] += 1
    end
    price
  end
end

grid   = ARGF.readlines(chomp:true).map(&:chars)
map    = Map.new(grid)

sum = 0
grid.each.with_index do |lines, row|
  lines.each.with_index do |crop, coll|
    if map[row,coll] != map[row,coll].downcase
      # puts "Explore: #{map[row,coll]}"
      price = Map.new(grid).explore(row, coll, crop)
      sum += price[:size] * price[:fences]
      # puts price.to_s
    end
  end
end

puts sum
