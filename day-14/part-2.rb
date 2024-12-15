class Map

  attr_reader :width, :height, :map

  def initialize(height:,width:)
    @height = height
    @width = width
    @robot = []
  end

  def push(vector, h:,w:)
    @robot << {h:,w:, vector:}
  end

  def run
    @robot.each do |r|
      h, w, vector = r[:h], r[:w], r[:vector]
      w,h = vector.apply(w,h)
      h = height + h if h < 0
      w = width + w if w < 0
      h = h - height if h >= height
      w = w - width if w >= width
      r[:h],r[:w] = h, w
    end
  end

  def possible?
    height.times do |h|
      return true if @robot.count {|r| r[:h] == h} >= 20
    end
    false
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
    height.times.map do |h|
      width.times.map do |w|
        cell = @robot.count {|r| r[:h] == h && r[:w] == w}
        if cell == 0
          '.'
        else
          cell.to_s
        end
      end.join ''
    end.join "\n"
  end
  def display
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
count = 50*3
robots = ARGF.readlines(chomp:true)

map = Map.new(height:, width:)
robots.each do |robot|
  w,h,vw,vh = robot.scan( /((?:-)?\d+)/).flatten.map &:to_i
  map.push(Vector.new(vw:,vh:), w:, h:)
end

count = 0
while true
  count += 1
  print "\r====== #{count} ======"
  map.run
  map.display if map.possible?
end


# 7037 CORRECT
