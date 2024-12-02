puts(STDIN.read.split("\n")
          .map { _1.split(' ').map(&:to_i) }
          .map! do |ar|
  res =
    if (ar.sort == ar || ar.sort.reverse == ar) && ar.each_cons(2).map { |a| a.reduce(&:-).abs }.all? {|i| i >= 1 && i <= 3 }
      'OK'
    else
      'KO'
    end

  if res == 'KO'
    ar.length.times do |i|
      arr = ar.clone
      arr.delete_at(i-1)
      if (arr.sort == arr || arr.sort.reverse == arr) && arr.each_cons(2).map { |a| a.reduce(&:-).abs }.all? {|i| i >= 1 && i <= 3 }
        res = 'OK'
        break
      end
    end
  end
  res
end.count{ _1 == 'OK' })
