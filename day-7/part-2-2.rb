# DOT NOT WORK - AT ALL
require 'concurrent'

class Validator
  attr_accessor :ope, :forbiden, :rejected, :search, :nbrs, :str

  def initialize(search, str)
    length = (str.split(' ').length) - 1
    @ope = %w[+ * |].repeated_permutation(length)

    @forbiden = Concurrent::Array.new
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
    thread_count = (5).clamp(0,operators.size-1)
    chunk = operators.size / thread_count
    found = Concurrent::AtomicBoolean.new

    thread = []
    thread_count.times do |i|
      thread << Thread.new do
        operators.clone.each.with_index do |oper, index|
          next unless (chunk * i <= index && index <= chunk * i+1)
          next if found.true?

          # print "\rf=#{forbiden.count}/#{rejected}|#{operators.size}|#{oper}"
          pattern = oper.join('')
          if forbiden.any? { pattern.start_with?(_1) }
            self.rejected += 1
            next
          end

          total = nbrs[0]
          nbrs[1..-1].each.with_index do |nbr, index|
            if total > search
              forbiden << oper[0..index].join('')
              next 0
            end
            case oper[index]
            when '+'
              total = total+nbr
            when '*'
              total = total*nbr
            when '|'
              total = (total.to_s+nbr.to_s).to_i
            end
          end

          found.make_true if search == total
        end
      end
    end

    follow(thread)
    found.value
  end
end

def follow(thread, limit: 0)
  start = Time.now
  # Démarrer un thread de surveillance pour afficher le nombre de Ractor actifs
  loop do
    active_thread = thread.count { |t| t.status }
    print "\rThread encore en cours : #{active_thread}/#{thread.count}     T:#{Time.now-start}"
    thread.select!{ _1.status }
    break if active_thread == 0 || active_thread < limit
    sleep(0.1)
  end
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

  # Retourner la somme totale
  puts "\nSUM:#{partial_sums.sum}"
ensure
  puts "T:#{Time.now - start}"
end

# Sample = 11387
# Data = 165278151522644

# Too high
# 770412853571675
# Too low
# 335155270007
# 43548803
