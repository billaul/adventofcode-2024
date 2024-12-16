class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  COLORS = %i[red green yellow blue pink light_blue]
  def cycle(i)
    self.send(COLORS[i % COLORS.length])
  end
  def red = colorize(31)
  def green = colorize(32)
  def yellow = colorize(33)
  def blue = colorize(34)
  def pink = colorize(35)
  def light_blue = colorize(36)

end

class Map

  VALUES = Hash.new {|h,v| h[v] = Hash.new {|h,v| h[v] = Float::INFINITY } }
  DIRECTION = {
    '^' => [-1,0],
    '>' => [0,1],
    '<' => [0,-1],
    'v' => [1,0],
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

  def find_robot
    @map.each.with_index do |line, x|
      line.each.with_index do |cell, y|
        return [x,y] if cell == 'S'
      end
    end
    raise 'Robot disapeard Oo !'
  end

  def exit
    return @exit if @exit.present?
    @map.each.with_index do |line, x|
      line.each.with_index do |cell, y|
        return (@exit = [x,y]) if cell == 'E'
      end
    end
    raise 'Exit disapeard Oo !'
  end

  def neigbores(x,y, exclude: nil)
    DIRECTION.map do |k, (dx,dy)|
      if exclude && exclude[:x] == x+dx && exclude[:y] == y+dy
        nil
      elsif self[x+dx,y+dy] == '.' || self[x+dx,y+dy] == 'E' || self[x+dx,y+dy] == 'S'
        { x: x+dx, y: y+dy, dir: k }
      else
        nil
      end
    end.compact
  end

  def solve(x=nil, y=nil, path = [])
    current_cost = path_cost(path)
    dir = (path.last[:dir] rescue '<')
    # Exclude this position if already visited with a shorter or equal path
    return if VALUES["#{x},#{y}"][dir] < current_cost || current_cost > $min_cost
    VALUES["#{x},#{y}"][dir] = current_cost

    print "\rPath: #{path.length} / $Paths #{$paths.length} / COST #{current_cost}/#{$min_cost}        "
    # sleep 0.2

    if x.nil?
      x, y = find_robot
    end

    if self[x,y] == 'E'
      $min_cost= [$min_cost, path_cost(path)].min
      display(path)
      $paths << path
      return true
    end

    # No backward
    nbs = neigbores(x,y, exclude: path[-2] || {x:, y:})
    return false if nbs.empty?

    # No Loops
    nbs = nbs.select do |nb|
      !path.find {|h| h[:x] == nb[:x] && h[:y] == nb[:y] }
    end

    return true if nbs.empty?

    if (nb = nbs.find { |nb| nb[:dir] == dir })
      solve(nb[:x],nb[:y], path.clone << nb)
    end

    nbs.each do |nb|
      next if nb[:dir] == dir
      solve(nb[:x],nb[:y], path.clone << nb)
    end
  end

  def to_s(path=[])
    @map.map.with_index do |line, x|
      line.map.with_index do |cell, y|
        if (nb = path.find { |h| h[:x] == x && h[:y] == y })
          nb[:dir]
        else
          cell
        end
      end.join ''
    end.join "\n"
  end
  def display(path=[])
    puts
    puts to_s(path)
    puts '========='
  end
  def save(path=[])
    File.write('output', to_s(path))
  end

  def deadend
    found = false

    @map.each.with_index do |line, x|
      line.each.with_index do |cell, y|
        next if cell != '.'
        if neigbores(x,y).count == 1
          self[x,y] = '#'
          found = true
        end
      end
    end

    if found
      deadend
    else
      display
    end
  end
end


def path_cost(path, p: false)
  path = path.map {|v| v[:dir]}
      .join('')
  path =  ">#{path}"

  lenght = path.length - 1
  path =
    path.gsub(/>+/, '>')
        .gsub(/<+/, '<')
        .gsub(/\^+/, '^')
        .gsub(/v+/, 'v')

  puts "#{path}" if p
  lenght + ((path.length - 1) * 1000)
end


$paths = []
$min_cost = 134588

grid = []
ARGF.readlines(chomp:true).each do |line|
  grid << line.chars
end
maze = Map.new(map: grid)
maze.display([])
maze.deadend
maze.solve
puts
puts '======'

maze.display($paths.last || [])
path_cost($paths.last, p: true)
puts $min_cost

# 134587
# 136592
# 136589
# 136584

# high
# 135588
# 253896
