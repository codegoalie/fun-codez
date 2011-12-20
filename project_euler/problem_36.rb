sum = 0
for i in 1..1000000
  puts "trying #{i}"
  sum += i if i.to_s == i.to_s.reverse &&
    i.to_s(2) == i.to_s(2).reverse
end
puts sum
