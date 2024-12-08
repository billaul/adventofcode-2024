
require 'concurrent'

class Validator
  attr_accessor :ope, :forbiden, :rejected, :search, :nbrs, :str

  def initialize(search, str)
    length = (str.split(' ').length) - 1
    @ope = %w[+ * |].repeated_permutation(length)

    @forbiden = []
    @rejected = 0
    @search = search
    @str = str
    @nbrs = str.dup.split(' ').map(&:to_i)
  end

  def valid!
    return false if @nbrs.join('').to_i < search
    valid?(ope)
  end

  def valid?(operators)
    operators.each.with_index do |oper,index|
      print "\rf=#{forbiden.count}/#{rejected}|#{index},#{operators.size}|#{oper}"
      pattern = oper.join('')
      if forbiden.any? { pattern.start_with?(_1) }
        self.rejected += 1
        next
      end

      total = nbrs[0]
      nbrs[1..-1].each.with_index do |nbr, index|
        next if total > search
        case oper[index]
        when '+'
          total = total+nbr
        when '*'
          total = total*nbr
        when '|'
          total = (total.to_s+nbr.to_s).to_i
        end
      end

      return true if search == total
    end
    false

  end
end

def save(str)
  File.write('output', "#{str}\n", mode: 'w+')
end

begin
  start = Time.now
  lines = ARGF.readlines(chomp:true)
  partial_sums = Concurrent::Array.new
  lines.each.with_index do |line, index|
    puts "\n#{index}/#{line}\n"

    search, str = line.split(': ')
    search = search.to_i

    if Validator.new(search, str).valid!
      partial_sums << search
    end

  end

  puts "\nSUM:#{partial_sums.sum}"
ensure
  puts "T:#{Time.now - start}"
end
