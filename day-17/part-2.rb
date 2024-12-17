class Computer
  OPCODES = {
    0 => :adv,
    1 => :bxl,
    2 => :bst,
    3 => :jnz,
    4 => :bxc,
    5 => :out,
    6 => :bdv,
    7 => :cdv
  }

  def combo(operand)
    case operand
    when 0,1,2,3
      operand
    when 4
      reg[:a]
    when 5
      reg[:b]
    when 6
      reg[:c]
    when 7
      raise 'Combo operand 7 is reserved and will not appear in valid programs'
    else
      raise 'FUCK'
    end
  end
  attr_accessor :instruction_pointer, :program, :reg, :outputs

  def initialize(program, a,b,c)
    @program = program
    @instruction_pointer = 0
    @reg = { a:, b:, c: }
    @outputs = []
    @jump = false
  end

  def reg_to_s
    "a:#{@reg[:a]}".ljust(10, ' ')+
      " b:#{@reg[:b]}".ljust(10, ' ')+
      " c:#{@reg[:c]}".ljust(10, ' ')
  end

  def process
    "instruction_pointer: #{instruction_pointer}"
    instruction = program[instruction_pointer]
    operand     = program[instruction_pointer+1]

    return if instruction.nil? # halts

    call(instruction, operand)
    process
    self
  end

  def display
    outputs.join(',')
  end
  private

  # OK 0 2

  def call(code, operand)
    @jump = false
    # print "#{reg_to_s} | P:#{code} => #{OPCODES[code]}(#{operand})"
    send(OPCODES[code], operand)
    # puts " | #{reg_to_s}"
    unless @jump
      @instruction_pointer += 2
    end

    # puts display if code == 5
  end
  # The adv instruction (opcode 0) performs division.
  # The numerator is the value in the A register.
  # The denominator is found by raising 2 to the power of
  # the instruction's combo operand. (So, an operand of 2 would
  # divide A by 4 (2^2); an operand of 5 would divide A by 2^B.)
  # The result of the division operation is truncated to an integer
  # and then written to the A register.
  def adv(operand)
    reg[:a] = reg[:a] / (2 ** combo(operand))
  end
  # The bxl instruction (opcode 1)
  # calculates the bitwise XOR of register B and the instruction's
  # literal operand, then stores the result in register B.
  def bxl(operand)
    reg[:b] = reg[:b] ^ operand
  end
  # The bst instruction (opcode 2)
  # calculates the value of its combo operand modulo 8
  # (thereby keeping only its lowest 3 bits), then writes that value
  # to the B register.
  def bst(operand)
    reg[:b] = combo(operand) % 8
  end
  # The jnz instruction (opcode 3) does nothing if the A register is 0.
  # However, if the A register is not zero, it jumps by setting the
  # instruction pointer to the value of its literal operand;
  # if this instruction jumps, the instruction pointer is not increased
  # by 2 after this instruction.
  def jnz(operand)
    return if reg[:a] == 0
    @jump = true
    @instruction_pointer = operand
  end
  # The bxc instruction (opcode 4) calculates the bitwise XOR
  # of register B and register C, then stores the result in register B.
  # (For legacy reasons, this instruction reads an operand but ignores it.)
  def bxc(_)
    reg[:b] = reg[:b] ^ reg[:c]
  end
  # The out instruction (opcode 5) calculates the value of
  # its combo operand modulo 8, then outputs that value.
  # (If a program outputs multiple values, they are separated by commas.)
  def out(operand)
    @outputs.push( combo(operand) % 8 )
  end
  # The bdv instruction (opcode 6) works exactly like the adv instruction
  # except that the result is stored in the B register.
  # (The numerator is still read from the A register.)
  def bdv(operand)
    reg[:b] =  reg[:a] / (2 ** combo(operand))
  end
  # The cdv instruction (opcode 7) works exactly like the adv instruction
  # except that the result is stored in the C register.
  # (The numerator is still read from the A register.)
  def cdv(operand)
    reg[:c] =  reg[:a] / (2 ** combo(operand))
  end
end

# Register A: 729
# Register B: 0
# Register C: 0
#
# Program: 0,1,5,4,3,0

registers = []
programs = ''
program = []
ARGF.readlines(chomp:true).each do |line, index|
  if line['Register']
    registers << line.scan(/\d+/).last.to_i
  elsif line['Program']
    programs = line[9..]
    program  = programs.split(',').map(&:to_i)
  end
end
puts program.join','

# Stolen from https://github.com/rolfschmidt/advent-of-code/blob/main/2024/spec/day17_spec.rb
def get_prev_reg(program, cursor, reg_a)
  (0..8).each do |optcode|
    # `out` fait un modulo 8 il faut donc multiplier la valeur candidate par 8
    # avant de faire la comparaison avec l'output rechercher
    # Il n'y avais pas besoin d'inverser TOUTES les operation, seulement `out`

    a = reg_a * 8 + optcode
    out = Computer.new(program, a, 0, 0).process.display
    puts "#{a}/ #{out} ? #{program[cursor..-1].join(',')}"
    if out == program[cursor..].join(',')
      return a if cursor.zero?

      ret = get_prev_reg(program, cursor - 1, a)
      return ret unless ret.nil?
    end
  end
  nil
end
puts program.join','
puts get_prev_reg(program, program.size - 1, 0)

# Sample-1 Expect  4,6,3,5,6,3,5,2,1,0
# Data - WRONG
# 5,5,3,7,4,7,0,1,1
# 7,1,3,7,5,1,0,3,4

# 190384113204239
