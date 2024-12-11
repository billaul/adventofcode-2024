require 'json'
require 'benchmark'

ZERO = [60, 72, 40, 48, 28676032, 28676032, 40, 48, 24579456, 3277, 2608, 4, 0, 4, 8, 20, 24, 4, 0, 4, 8, 8, 0, 9, 6, 60, 72, 24579456, 32772608, 24579456, 36869184, 20, 24, 32772608, 80, 96, 40, 48, 80, 96, 20482880, 28676032, 36869184, 80, 96, 20482880, 24579456, 8, 0, 9, 6, 20, 24, 8, 0, 9, 6, 3277, 2608, 40, 48, 2024, 40, 48, 80, 96, 8, 0, 9, 6, 20, 24, 8, 0, 9, 6, 3277, 2608, 3277, 2608, 20, 24, 3686, 9184, 2457, 9456, 60, 72, 40, 48, 28676032, 28676032, 40, 48, 24579456, 3277, 2608, 4, 0, 4, 8, 20, 24, 4, 0, 4, 8, 8, 0, 9, 6, 60, 72, 24579456, 32772608, 24579456, 36869184, 20, 24, 32772608, 80, 96, 40, 48, 80, 96, 20482880, 28676032, 36869184, 80, 96, 20482880, 24579456, 24579456, 2024, 28676032, 40, 48, 80, 96, 2024, 80, 96, 32772608, 2, 8, 6, 7, 6, 0, 3, 2, 2, 8, 6, 7, 6, 0, 3, 2, 80, 96, 2024, 80, 96, 32772608, 2, 4, 5, 7, 9, 4, 5, 6, 6072, 4048, 14168, 14168, 4048, 12144, 32772608, 3277, 2608, 20, 24, 3686, 9184, 2457, 9456, 40, 48, 2024, 40, 48, 80, 96, 3277, 2608, 20, 24, 3686, 9184, 2457, 9456, 6072, 4048, 14168, 14168, 4048, 12144, 32772608, 80, 96, 2024, 80, 96, 32772608, 4048, 1, 4048, 8096, 80, 96, 2024, 80, 96, 32772608, 32772608, 2024, 36869184, 24579456, 3277, 2608, 20, 24, 3686, 9184, 2457, 9456, 40, 48, 2024, 40, 48, 80, 96, 3277, 2608, 20, 24, 3686, 9184, 2457, 9456, 6072, 4048, 14168, 14168, 4048, 12144, 32772608, 6072, 4048, 14168, 14168, 4048, 12144, 32772608, 40, 48, 2024, 40, 48, 80, 96, 6072, 12144, 16192, 12144, 18216, 2024, 16192, 8096, 4048, 8096, 10120, 14168, 18216, 8096, 10120, 12144, 60, 72, 40, 48, 28676032, 28676032, 40, 48, 24579456, 3277, 2608, 4, 0, 4, 8, 20, 24, 4, 0, 4, 8, 8, 0, 9, 6, 60, 72, 24579456, 32772608, 24579456, 36869184, 20, 24, 32772608, 80, 96, 40, 48, 80, 96, 20482880, 28676032, 36869184, 80, 96, 20482880, 24579456, 8, 0, 9, 6, 20, 24, 8, 0, 9, 6, 3277, 2608, 40, 48, 2024, 40, 48, 80, 96, 8, 0, 9, 6, 20, 24, 8, 0, 9, 6, 3277, 2608, 3277, 2608, 20, 24, 3686, 9184, 2457, 9456, 60, 72, 40, 48, 28676032, 28676032, 40, 48, 24579456, 3277, 2608, 4, 0, 4, 8, 20, 24, 4, 0, 4, 8, 8, 0, 9, 6, 60, 72, 24579456, 32772608, 24579456, 36869184, 20, 24, 32772608, 80, 96, 40, 48, 80, 96, 20482880, 28676032, 36869184, 80, 96, 20482880, 24579456, 24579456, 2024, 28676032, 40, 48, 80, 96, 2024, 80, 96, 32772608, 2, 8, 6, 7, 6, 0, 3, 2, 2, 8, 6, 7, 6, 0, 3, 2, 80, 96, 2024, 80, 96, 32772608, 2, 4, 5, 7, 9, 4, 5, 6, 6072, 4048, 14168, 14168, 4048, 12144, 32772608, 24579456, 2024, 28676032, 40, 48, 80, 96, 2024, 80, 96, 32772608, 2, 8, 6, 7, 6, 0, 3, 2, 2, 8, 6, 7, 6, 0, 3, 2, 80, 96, 2024, 80, 96, 32772608, 2, 4, 5, 7, 9, 4, 5, 6, 6072, 4048, 14168, 14168, 4048, 12144, 32772608, 8, 0, 9, 6, 20, 24, 8, 0, 9, 6, 3277, 2608, 40, 48, 2024, 40, 48, 80, 96, 8, 0, 9, 6, 20, 24, 8, 0, 9, 6, 3277, 2608, 3277, 2608, 20, 24, 3686, 9184, 2457, 9456, 24579456, 2024, 28676032, 40, 48, 2, 4, 5, 7, 9, 4, 5, 6, 3, 2, 7, 7, 2, 6, 16192, 2, 4, 5, 7, 9, 4, 5, 6, 3, 6, 8, 6, 9, 1, 8, 4, 40, 48, 2024, 40, 48, 80, 96, 3, 2, 7, 7, 2, 6, 16192, 32772608, 2024, 36869184, 24579456, 80, 96, 2024, 80, 96, 32772608, 32772608, 2024, 36869184, 24579456, 2, 0, 4, 8, 2, 8, 8, 0, 2, 8, 6, 7, 6, 0, 3, 2, 3, 6, 8, 6, 9, 1, 8, 4, 32772608, 2024, 36869184, 24579456, 2, 0, 4, 8, 2, 8, 8, 0, 2, 4, 5, 7, 9, 4, 5, 6]

def save(line)
  File.write('output', line.to_s)
end

def debug(str = nil, &block)
  return unless $DEBUG
  puts(str) if str
  block.call if block_given?
end

$nodes = {}

class Node
  attr_reader :value
  attr_accessor :left, :right

  def initialize(value,left=nil,right=nil)
    @value = value
    @left  = Node.new(left) if left
    @right = Node.new(right) if right
    $nodes[value] = self
    # puts "CN: #{$nodes.size}"
  end

  def self.find_or_create(value)
    $nodes[value] || Node.new(value)
  end

  def self.push(v, v_left, v_right=nil)
    raise 'FUCK' if v == v_left || v == v_right || v_left == nil

    node       = find_or_create(v)
    node.left  = find_or_create(v_left) if node.left.nil?
    node.right = find_or_create(v_right) if node.right.nil? && v_right
    node
  end

  def blink(deep)
    if !$deep.include?(deep)
      print "\rdeep: #{deep}   "
      $deep << deep
    end

    debug "blink [#{@left&.value},#{@right&.value}] ask:#{deep}"
    if deep == 0
      # debug { $final_line << value }
      $total_count += 1
      # puts $total_count
    elsif @left
      @left.blink(deep-1)
      @right&.blink(deep-1)
    else
      new_stone =
        if value == 0
          1
        elsif (Math.log10(value).floor + 1).even?
          pow = 10**((Math.log10(value).floor + 1)/2)
          [value / pow , value % pow]
        else
          value * 2024
        end

      Node.push(value, *new_stone).blink(deep)
    end
    nil
  end

  def all
    [value, @left&.all, @right&.all].compact
  end
end

$stones = Hash.new { |h,stone|
  if stone == 0
    h[stone] = 1
  elsif (Math.log10(stone).floor + 1).even?
    pow = 10**((Math.log10(stone).floor + 1)/2)
    h[stone] = [stone / pow , stone % pow]
  else
    h[stone] = stone * 2024
  end
}

$zero = Hash.new { |h, deep|
  [$stones[0], h[deep-1]]
}

def blinks(stones, deep)
  puts "Blink Stone #{stones}" if deep == @BLINKS-1
  debug "\nCount: #{$total_count} / Nodes: #{$stones.count}"

  [*stones].each do |stone|

    if stone == 0 && deep >= 17
      blinks(ZERO, deep - 17)
    elsif deep == 0
      debug { $final_line << stone }
      $total_count += 1
    else
      blinks($stones[stone], deep - 1)
    end
  end;0
  nil
end

def part1(check, count)
  count.times do |i|
    check.clone.each do |num, count|
      new_values = if num == 0
                     [1]
                   elsif num.to_s.length % 2 == 0
                     pow = 10**((Math.log10(num).floor + 1)/2)
                     [num / pow , num % pow]
                   else
                     [num * 2024]
                   end

      check[num] -= count
      new_values.each do |value|
        check[value] ||= 0
        check[value] += count
      end
    end
  end

  check.values.sum
end


def part2(check, count)
  count.times do |i|
    check.clone.each do |num, count|
      next if count == 0
      new_values = if num == 0
                     [1]
                   elsif num.to_s.length % 2 == 0
                     pow = 10**((Math.log10(num).floor + 1)/2)
                     [num / pow , num % pow]
                   else
                     [num * 2024]
                   end

      check[num] -= count
      new_values.each do |value|
        check[value] ||= 0
        check[value] += count
      end
    end
  end

  check.values.sum
end



$tree = Node.new(0, 1)

$DEBUG = false
# $DEBUG = true

# puts "-=-=-=-=-=-=-=-=-=-=-=-=-"
# $final_line = []
# $total_count = 0
# blinks( [125, 17], 0)
# puts "B:#{3}F: #{$final_line.flatten.join(' ').to_s}"
# puts "      125 17"
# puts "Count: #{$total_count}"
# puts "-=-=-=-=-=-=-=-=-=-=-=-=-"
# $final_line = []
# $total_count = 0
# blinks( [125, 17], 3)
# puts "B:#{3}F: #{$final_line.flatten.join(' ').to_s}"
# puts "      512072 1 20 24 28676032"
# puts "Count: #{$total_count}"
# puts "-=-=-=-=-=-=-=-=-=-=-=-=-"
# $final_line = []
# $total_count = 0
# blinks( [125, 17], 4)
# puts "B:#{4}F: #{$final_line.flatten.join(' ').to_s}"
# puts "      512 72 2024 2 0 2 4 2867 6032"
# puts "Count: #{$total_count}"
# puts "-=-=-=-=-=-=-=-=-=-=-=-=-"
# $final_line = []
# $total_count = 0
# blinks( [125, 17], 6)
# puts "B:#{4}F: #{$final_line.flatten.join(' ').to_s}"
# puts "      2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2"
# puts "Count: #{$total_count}"
# puts "-=-=-=-=-=-=-=-=-=-=-=-=-"
stone_line = ARGF.readlines(chomp:true)[0].split(' ').map &:to_i

Benchmark.bm do |x|
  x.report { puts part1(Hash[stone_line.map { [_1, 1]}], 75) }
  x.report { puts part2(Hash[stone_line.map { [_1, 1]}], 75) }
end

exit

@BLINKS = 17
$final_line = []
$total_count = 0
blinks([0], @BLINKS)
puts "Count: #{$total_count}"

@BLINKS = 25
$total_count = 0
blinks([125 ,17], @BLINKS)
puts "Count: #{$total_count}"

$total_count = 0
@BLINKS = 25
puts "BLINKS #{@BLINKS}"
stone_line = ARGF.readlines(chomp:true)[0].split(' ').map &:to_i
blinks(stone_line, @BLINKS)
puts "Count: #{$total_count}"

$total_count = 0
@BLINKS = 35
puts "BLINKS #{@BLINKS}"
blinks(stone_line, @BLINKS)
puts "Count: #{$total_count}"
exit

$total_count = 0
@BLINKS = 75
puts "BLINKS #{@BLINKS}"
blinks(stone_line, @BLINKS)
puts "Count: #{$total_count}"
