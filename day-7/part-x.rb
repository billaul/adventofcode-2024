# Stolen from https://github.com/soupglasses/advent-of-code/blob/main/2024/ruby/day_07.rb
# Just to remember that's actualy possible
# I'mean ... WHAT THE FUCK IS THIS ?!?

class Integer
  def length
    Math.log10(self).floor + 1
  end

  def end_with?(other)
    (self - other) % 10 ** other.length == 0
  end
end

def can_fit?(target, numbers, concat: false)
  *remaining, n = numbers
  return n == target if remaining.empty?

  # Multiply
  return true if (target % n).zero? && can_fit?(target / n, remaining, concat:)
  # Concat
  return true if concat && target.end_with?(n) && can_fit?(target / (10**n.length), remaining, concat:)

  # Sum
  can_fit?(target - n, remaining, concat:)
end


lines = ARGF.readlines(chomp:true)
@evaluations = lines.map { _1.scan(/\d+/).map(&:to_i) }
puts @evaluations.select { |total, *numbers| can_fit?(total, numbers, concat: true) }.sum(&:first)
