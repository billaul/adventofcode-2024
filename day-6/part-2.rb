map = ARGF.readlines(chomp:true).map(&:chars)

$cros = 0
class Map < Array

  DIRECTION = {
    '^' => [-1,0],
    '>' => [0,1],
    'v' => [1,0],
    '<' => [0,-1],
  }
  GUARD = %w[^ > v <]
  DIR   = %w[| - | -]
  attr_accessor :i
  attr_accessor :j
  attr_accessor :direction

  def initialize(map)
    @map = map
    @i = 0
    @j = 0
    @direction = nil
    @path = Path.new
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
    puts '========='
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

  def count_obstacle
    @map.flatten.count {_1 == 'O'}
  end

  def find_guard
    @map.each.with_index do |line, i|
      line.each.with_index do |cell, j |
        if GUARD.include?(cell)
          @i = i
          @j = j
          self.direction = self[i,j]
          return
        end
      end
    end
  end

  def move

    while true
      a, b = DIRECTION[direction]
      next_cell = self[i + a, j + b]
      if next_cell.nil? || (i + a) < 0 || (j + b) < 0
        return
      elsif next_cell == '#'
        turn
      else
        forward(a,b)
      end
    end
  end

  def turn
    self.direction = next_direction
  end

  def next_direction(from = direction)
    GUARD[(GUARD.index(from) + 1) % GUARD.length]
  end

  def check_square
    new_obstacle if prospect(Vector.new(i, j, next_direction, self), @path)
  end

  class Path
    def initialize
      @path = {}
      @length = 0
    end
    def push(i,j,dir)
      @length += 1
      @path[i] ||= {}
      @path[i][j] ||= Set.new
      @path[i][j] << dir
    end
    def [](i,j,dir)
      @path[i][j].include?(dir) rescue nil
    end
    def length
      @length
    end
  end

  class Vector
    attr_accessor :i, :j, :a, :b, :direction
    attr_reader :map
    def initialize(i,j, direction, map)
      @i = i
      @j = j
      @direction = direction
      @a, @b = *Map::DIRECTION[direction]
      @map = map
    end

    def next = map[i+a, j+b]
    def next!
      @i = i+a
      @j = j+b
    end
    def next? = i + a > 0 && j + b > 0 && self.next != nil
    def cur = map[i, j]
    def rot
      @direction = map.next_direction(direction)
      @a, @b = *Map::DIRECTION[direction]
      self
    end
    def pos = [i,j, direction]
  end

  def prospect(v, history)
    path = Path.new
    v.rot if v.next == '#'
    while v.next?
      if history[*v.pos] || path[*v.pos]
        return true
      elsif v.next == '#'
        v.rot
      else
        path.push(*v.pos)
        v.next!
      end
    end

  end

  def new_obstacle
    a,b = DIRECTION[direction]
    if self[i+a,j+b] != 'O'
      self[i+a,j+b] = 'O'
      save
      puts count_obstacle
    end
  end

  def forward(a,b, mark: true)
    while ((i + a) >= 0 || (j + b) >= 0) && self[i+a,j+b] && self[i+a,j+b] != '#'
      breadcrumb if mark
      check_square

      @path.push( i,j,direction)
      @i = i + a
      @j = j + b
    end
    breadcrumb if mark
  end

  def breadcrumb
    if self[i,j] == '.'
      self[i,j] = DIR[GUARD.index(direction)]
    elsif DIR.include?(self[i,j])
      self[i,j] = '+'
    end
  end

  def start
    catch 'Finish' do
      find_guard
      move
    end
  end

end

map = Map.new(map)
map.start
map.print
map.save
puts "Final: #{map.count_obstacle}"
