$debug = false



def recursive_chop(find, array)
  return -1 if array.size <= 0
  if array.size == 1 
    return find == array[0] ? 0 : -1
  end

  return find_within(find, array, 0, array.size-1)
end

def find_within(find, array, start, stop)
  if start >= stop
    return find == array[start] ? start : -1
  end
  current = (start + stop) / 2
  case find <=> array[current]
  when 0
    return current
  when 1 # gt
    start = current + 1
  when -1
    stop = current -1
  end
  find_within(find, array, start, stop)
end

def iterative_chop(find, array)
  start = 0
  stop = array.size-1

  puts "array : #{array.inspect}" if $debug
  puts "start: #{start}" if $debug
  puts "stop: #{stop}" if $debug

  i = 0
  while start < stop && i < 7
    puts "it: #{i}" if $debug
    i+=1
    current = ( stop + start )/2
    puts "current: #{current}" if $debug
    puts "start: #{start}" if $debug
    puts "stop: #{stop}" if $debug
    
    if find == array[current]
      puts 'found' if $debug
      return current
    elsif find > array[current]
      puts 'gt; start = current' if $debug
      start = current + 1
    else
      puts 'lt; stop = current' if $debug
      stop = current - 1
    end
  end
  return start if find == array[start]
  -1
end
