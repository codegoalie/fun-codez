(1..100).each do |i|
  output = ''
  output += "Bizz " if i % 3 ==0
  output +=  "Buzz" if i % 5 ==0
  output = i if output == ''
  puts output
end
