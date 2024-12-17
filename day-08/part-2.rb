$grid = ARGF.readlines(chomp:true).map(&:chars)
$antinodes = Marshal.load( Marshal.dump($grid) )

def save(str)
  File.write('output', "#{str}\n", mode: 'w+')
end

class Vector
  attr_accessor :v_col, :v_row
  def initialize(v_col, v_row)
    @v_col = v_col
    @v_row = v_row
  end
  def apply(col, row)
    col = col + v_col
    row = row + v_row
    return if col < 0 || row < 0 || $antinodes.dig(col,row).nil?
    $antinodes[col][row] = "#"

    Vector.new(v_col, v_row).apply(col, row) # Etape 2
  end
end

class Antena
  attr_accessor :col, :row, :letter
  def initialize(letter, col, row )
    @letter = letter
    @col = col
    @row = row
  end

  def antinodes
    $grid.each.with_index do |line, col|
      line.each.with_index do  |cell, row|
        next if col == self.col && row == self.row
        next if cell != letter
        $antinodes[col][row] = "#"
        Vector.new(col - self.col, row - self.row).apply(col, row)
      end
    end
  end
end

def explore(letter)
  $grid.each.with_index do |line, col|
    line.each.with_index do  |cell, row|
      Antena.new(letter, col, row).antinodes if cell == letter
    end
  end
end

antena = $grid.flatten.select { _1 != '.' }
antena = antena.select { antena.count(_1) > 1 }
antena.each do |letter|
  explore(letter)
end

save $antinodes.map{ _1.join('') }.join("\n")
puts $antinodes.flatten.count { _1 == '#' }
