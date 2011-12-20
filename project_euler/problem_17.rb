ONES = { '1' => 'one', '2' => 'two', '3' => 'three', '4' => 'four', '5' => 'five',
         '6' => 'six', '7' => 'seven', '8' => 'eight', '9' => 'nine', '10' => 'ten',
         '11' => 'eleven', '12' => 'twelve', '13' => 'thirteen', '14' => 'fourteen',
         '15' => 'fifteen', '16' => 'sixteen', '17' => 'seventeen', '18' => 'eighteen',
         '19' => 'nineteen' }
TENS = { '2' => 'twenty', '3' => 'thirty', '4' => 'forty', '5' => 'fifty', '6' => 'sixty',
         '7' => 'seventy', '8' => 'eighty', '9' => 'ninety' }

HUNDRED = 'hundredand'

def total_letters(num)
  string = num.to_s
  return 'onethousand'.size if num == 1000
  return "#{ONES[string[0]]}hundred".size if num % 100 == 0

  if num > 99
    puts "#{string[0]} hundred and "
    return (ONES[string[0]] + HUNDRED).size + total_letters(num % 100)
  else
    if num > 19
      return TENS[string[0]].size if num % 10 == 0

      puts ONES[string[1]]
      return TENS[string[0]].size + 
        total_letters(num % 10)
    else
      return ONES[string].size
    end
  end
end

sum = 0
for i in 1..1000
  puts i
  sum += total_letters(i)
end

puts "Total: #{sum}"
