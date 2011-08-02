require 'readline'
require 'twitter'
require 'chronic'

CONSUMER_KEY =        "yjyqHNeu8EB3WLngq3E9GQ"
CONSUMER_SECRET =     "rzAu6jWbNuwof6lDv3b2HGqLj9WtgzWtJbD20YdjY"
OAUTH_TOKEN =         "14871281-Auzg5NHlwoogOAlE4lqeY23s61Mq43p6yqk1DWdGD"
OAUTH_TOKEN_SECRET =  "VeGsQeFnwcrdz4eKbN3b9uo40QQil4NMy07aV7ICb1Q"

PROMPT = '> '

mutex = Mutex.new

def print_tweets(tweets)
  tweets.reverse_each do |tweet|
    date_string = Chronic.parse(tweet.created_at).strftime("%k:%M")
    print "#{date_string} <#{tweet.user.screen_name}> #{tweet.text}\n"
  end
end

def fetch_initial_timeline
  initial_timeline = $client.home_timeline
  print_tweets(initial_timeline)
  $last_tweet_id = initial_timeline.first.id
end

def fetch_timeline
  print "\nFetching more tiemline...\n"
  print "fetch timeline Last tweet ID: #{$last_tweet_id}\n"
  timeline = $client.home_timeline( :since_id => $last_tweet_id )
  print_tweets(timeline)
  $last_tweet_id = timeline.first.id if timeline
  timeline = nil
end

def before_exit
  puts "\nThanks for Tweeting!"
end







stty_save = `stty -g`.chomp
trap('INT') { system('stty', stty_save); before_exit; exit }

Twitter.configure do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.oauth_token = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_TOKEN_SECRET
end

$last_tweet_id = 0

$client = Twitter::Client.new
puts "Fetching timeline..."
fetch_initial_timeline

time_to_wait = 30
last_fetch = Time.now

Thread.new do
  loop do
    last_id = $last_tweet_id
    print "Waiting #{last_fetch + time_to_wait - Time.now} seconds" if (Time.now - last_fetch) % 1 == 0
    if Time.now > last_fetch + time_to_wait
      line = Readline.line_buffer
      fetch_timeline
      print "Last tweet ID: #{$last_tweet_id}\n"
      last_fetch = Time.now
      print "\n#{PROMPT}#{line}" if last_id != $last_tweet_id
    end
  end
end
loop do
  line = Readline.readline(PROMPT, true)
  p line if line
end

while true

  line = Readline.line_buffer('> ', true)
  p line unless line == ''
end

