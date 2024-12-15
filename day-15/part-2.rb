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
    # puts "[#{x},#{y}] [#{dx},#{dy}] #{self[x,y]}"
    if self[x,y] == '.'
      [x,y]
    elsif self[x,y] == '#'
      false
    else
      movable?(x+dx,y+dy,dx,dy)
    end
  end

  def h_movable?(x,y,dy)
    # puts "h_movable?"
    to_move = []
    if self[x,y] == '.'
      [true]
    elsif self[x,y] == '#'
      [false]
    elsif self[x,y] == '[' || self[x,y] == ']'
      to_move << {x:,y:}
      to_move << h_movable?(x,y+dy, dy)
    end
  end

  def v_movable?(x,y,dx)
    # puts "v_movable?"
    to_move = []
    if self[x,y] == '.'
      [true]
    elsif self[x,y] == '#'
      [false]
    elsif self[x,y] == '['
      to_move << {x:,y:}
      to_move << {x:,y:y+1}

      to_move << v_movable?(x+dx,y, dx)
      to_move << v_movable?(x+dx,y+1, dx)
    elsif self[x,y] == ']'
      to_move << {x:,y:}
      to_move << {x:,y:y-1}

      to_move << v_movable?(x+dx,y, dx)
      to_move << v_movable?(x+dx,y-1, dx)
    end
  end


  def play(instruction)
    dir = instruction

    dx,dy = DIRECTION[dir]
    cell = self[rx+dx,ry+dy]

    if cell == '.'
      self[rx,ry] = '.'
      @rx += dx
      @ry += dy
      self[rx,ry] = '@'

    elsif dir == '<' || dir == '>'
      movable = h_movable?(rx,ry+dy,dy).flatten.uniq.reverse
      # puts "#{movable.any? { _1 === true }} | #{movable.to_s}"

      if movable.any? { _1 === true }
        movable.each do |b|
          next if b === true
          # puts "[#{b[:x]},#{b[:y]+dy}] [#{b[:x]},#{b[:y]}]"
          self[b[:x], b[:y] + dy] = self[b[:x], b[:y]]
          self[b[:x], b[:y]] = '.'
          # display
        end

        self[rx,ry] = '.'
        @rx += dx
        @ry += dy
        self[rx,ry] = '@'
      end
    elsif dir == '^' || dir == 'v'
      movable = v_movable?(rx+dx,ry,dx).flatten.reverse.uniq
      # puts "#{movable.any? { _1 === true }} | #{movable.to_s}"

      unless movable.any? { _1 === false }
        movable.each do |b|
          next if b === true
          # puts "[#{b[:x]},#{b[:y]+dy}] [#{b[:x]},#{b[:y]}]"
          self[b[:x] + dx, b[:y]] = self[b[:x], b[:y]]
          self[b[:x], b[:y]] = '.'
          # display
        end

        self[rx,ry] = '.'
        @rx += dx
        @ry += dy
        self[rx,ry] = '@'
      end
    end

    display
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
        sum += 100 * x + y if cell == '['
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
CONVERT = !false
ARGF.readlines(chomp:true).each do |line|

  if line.start_with? '#'
    if CONVERT
      grid << line.chars.flat_map do |c|
        if c == '.'
          %w[. .]
        elsif c == '@'
          %w[@ .]
        elsif c == 'O'
          %w[[ ]]
        elsif c == '#'
          %w[# #]
        else
          puts c
          raise 'FUCK'
        end
      end
    else
      grid << line.chars
    end
  elsif line.length != 0
    instructions += line.split ''
  end
end
map = Map.new(map: grid)
map.display

instructions.each.with_index do |instruction,index|
  print "\r#{index+1}/#{instructions.length}    "
  map.play instruction
  exit if map.to_s['[.']
end
map.display
puts map.gps


# 1523427 Low
