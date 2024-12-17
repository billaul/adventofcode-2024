lines = ARGF.readlines(chomp:true)

def valid?(pages)
  pages.each.with_index do |page, index|
    next if index.zero?

    prev_page = pages[index - 1]
    return false unless @rules[prev_page]&.include?(page)
  end
  true
end

# Stupid and slow A* Solution
# def reorder_all(listes)
#   reorder_listes = []
#   listes.each.with_index do |pages, index|
#     # puts pages.to_s
#     pages.permutation(2) do |(first, last)|
#       # puts "#{first}/#{last}"
#       # puts "=> [(#{first}, #{last})]"
#       ordered_pages = reorder_pages(first, last, pages - [first,last])
#       # puts "[#{ordered_pages}]"
#       if ordered_pages
#         reorder_listes << [first, *ordered_pages, last]
#         break
#       end
#       # break if ordered_pages
#       # puts(ordered_pages[ordered_pages.length / 2].flatten) if ordered_pages
#     end
#   end
#   reorder_listes
# end

# Smart https://github.com/soupglasses sort Solution
def reorder_all(listes)
  listes.map do |pages|
    pages.sort { |l, r| @rules[l]&.include?(r) ? 1 : -1 }
  end
end

def reorder_pages(current, last, remaining_pages, path: [])
  # puts "#{current},#{path},#{last} / #{remaining_pages}"
  # Est-ce que les pages restantes sont vide ET qu'on peut aller de current vers last
  if remaining_pages.empty?
    if (@rules[current] || []).include?(last)
      # puts "FINAL #{path}"
      return path
    else
      return false
    end
  end

  # SINON est-ce qu'on peut aller de current vers une des pages restantes
  possible_pages = (((@rules[current] || []) & remaining_pages) - [last])
  # puts "#{current},#{path},#{last} / #{remaining_pages},#{possible_pages}"
  return false if possible_pages.empty?

  # SI OUI on test chaque page
  possible_pages.each do |page|
    possible_path = reorder_pages(page, last, remaining_pages - [page], path: [page, *path])
    if possible_path
      # SI ça marche on retourne le chemin
      # puts "STEP #{possible_path}"
      return possible_path
    end
  end

  # puts "FAILED"
  false
end

listes = []
@rules = {}
lines.each do |line|
  if line['|']
    a,b = line.split('|')
    @rules[a] ||= []
    @rules[a] << b
    @rules[a] = @rules[a].uniq
  elsif line[',']
    line = line.split(',')
    listes << line unless valid?(line)
  end
end

reorder_listes = reorder_all(listes[0..1])
 reorder_listes.map { puts _1.to_s }

puts reorder_listes.map { _1[_1.length/2].to_i  }.sum
