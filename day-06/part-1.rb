map = ARGF.readlines(chomp:true).map(&:chars)

class Map < Array

  DIRECTION = {
    '^' => [-1,0],
    '>' => [0,1],
    'v' => [1,0],
    '<' => [0,-1],
  }
  GUARD = %w[^ > v <]

  def initialize(map)
    @map = map
  end

  def [](x, y)
    return nil if x < 0 || y < 0
    @map.dig(x,y)
  end

  def []=(x, y, value)
    return nil if x < 0 || y < 0
    @map[x][y] = value
  end

  def print
    @map.each do
      puts _1.join('')
    end
  end

  def save
    File.write('output', @map.map do
      _1.join('')
    end.join("\n"))
  end

  def count_x
    @map.flatten.count {_1 == 'X'}
  end

  def find_guard
    @map.each.with_index do |line, i|
      line.each.with_index do |cell, j |
        return [i,j] if GUARD.include?(cell)
      end
    end
  end

  def move(i,j)
    raise 'FUCK' unless GUARD.include?(self[i, j])

    while true
      a, b = DIRECTION[self[i, j]]
      next_cell = self[i + a, j + b]
      if next_cell.nil? || (i + a) < 0 || (j + b) < 0
        self[i,j] = 'X'
        return
      elsif next_cell == '#'
        turn(i,j)
      else
        x = count_x
        current_direction = self[i, j]
        while ((i + a) >= 0 || (j + b) >= 0) && self[i+a,j+b] && self[i+a,j+b] != '#'
          self[i,j] = 'X'
          i = i + a
          j = j + b
        end
        self[i,j] = current_direction
        puts x
        return if count_x == x
      end
    end
  end

  def turn(i,j)
    guard = self[i, j]
    self[i,j] = GUARD[(GUARD.index(guard) + 1) % GUARD.length]
  end

  def start
    move(*find_guard)
  end

end

map = Map.new(map)
map.start
map.print
map.save
puts "Final: #{map.count_x}"
