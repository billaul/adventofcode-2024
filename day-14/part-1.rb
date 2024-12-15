class Map

  attr_reader :width, :height, :map

  def initialize(height:,width:)
    @height = height
    @width = width
    @map = Array.new(height){Array.new(width) {0}}
  end

  def push(vector, count,h:,w:)
    self[h,w] += 1

    # puts "[#{y},#{x}]"
    # save

    return if count.zero?

    # -1 on current position
    self[h,w] -= 1

    # New x,y
    w,h = vector.apply(w,h)
    h = height + h if h < 0
    w = width + w if w < 0
    h = h - height if h >= height
    w = w - width if w >= width

    # +1 on next position
    push(vector, count - 1, h:, w:)
  end

  def [](h,w)
    w = w % width if w >= width
    h = h % height if h >= height

    @map.dig(h,w)
  end
  def []=(h, w, value)
    @map[h][w] = value
  end
  def to_s
    @map.map.with_index do |line, row|
      line.map.with_index do |cell, coll|
        if coll == width / 2
          '|'
        elsif row == height / 2
          '-'
        elsif cell == 0
          '.'
        else
          cell
        end
      end.join ''
    end.join "\n"
  end
  def display
    puts '========='
    puts to_s
  end
  def save
    File.write('output', to_s)
  end

  def quadrant
    hash = {}
    @map.each.with_index do |line, row|
      line.each.with_index do |cell, coll|
        next if cell == '.' || row == height / 2 || coll == width / 2

        hash[[row < height / 2, coll < width / 2 ]] ||= 0
        hash[[row < height / 2, coll < width / 2 ]] += cell
      end
    end
    hash
  end
end

class Vector
  attr_accessor :v_col, :v_row
  def initialize(vh:, vw:)
    @vw = vw
    @vh = vh
  end
  def apply(w, h)
    [@vw + w, @vh + h]
  end
end

width,height = 11, 7
width,height = 101, 103

map = Map.new(height:, width:)
robots = ARGF.readlines(chomp:true)
robots.each do |robot|
  puts robot
  w,h,vw,vh = robot.scan( /((?:-)?\d+)/).flatten.map &:to_i
  map.push(Vector.new(vw:,vh:), 100, w:, h:)
  map.save
end
map.display
puts map.map.flatten.map(&:to_i).sum
puts map.quadrant.to_s
puts map.quadrant.values.reduce &:*

# 316725742 height

# 218965032 CORRECT

# 220160370 Low
# 216725742 Low
# 213624320 Low
