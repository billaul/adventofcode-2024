class Map

  DIRECTION = {
    '>' => [0,1],
    '<' => [0,-1],
    'v' => [1,0],
    '^' => [-1,0],
  }
  attr_reader :map, :rx, :ry

  def initialize(map:)
    @map = Marshal.load(Marshal.dump(map))
    @rx , @ry = find_robot
  end

  def [](x,y)
    @map.dig(x,y)
  end
  def []=(x, y, value)
    @map[x][y] = value
  end

  def movable?(x,y,dx,dy)
    puts "[#{x},#{y}] [#{dx},#{dy}] #{self[x,y]}"
    if self[x,y] == '.'
      [x,y]
    elsif self[x,y] == '#'
      false
    else
      movable?(x+dx,y+dy,dx,dy)
    end
  end

  def play(instruction)
    dir = instruction

    dx,dy = DIRECTION[dir]
    cell = self[rx+dx,ry+dy]

    if (px, py = movable?(rx+dx,ry+dy,dx,dy))
      self[rx,ry] = '.'
      @rx += dx
      @ry += dy
      self[rx,ry] = '@'
      self[px,py] = 'O' if cell == 'O'

    end
    # display
  end

  def find_robot
    @map.each.with_index do |line, x|
      line.each.with_index do |cell, y|
        return [x,y] if cell == '@'
      end
    end
    raise 'Robot disapeard Oo !'
  end

  def gps
    sum = 0
    @map.each.with_index do |line, x|
      line.each.with_index do |cell, y|
        sum += 100 * x + y if cell == 'O'
      end
    end
    sum
  end

  def to_s
    @map.map do |line|
      line.map do |cell|
        cell
      end.join ''
    end.join "\n"
  end
  def display
    puts
    puts to_s
    puts '========='
  end
  def save
    File.write('output', to_s)
  end


end

grid = []
instructions = []
 ARGF.readlines(chomp:true).each do |line|
 if line.start_with? '#'
   grid << line.chars
 elsif line.length != 0
  instructions += line.split ''
 end
end
map = Map.new(map: grid)


map.display

instructions.each.with_index do |instruction,index|
  print "\r#{index}/#{instructions.length}    "
  map.play instruction
end
map.display
puts map.gps
