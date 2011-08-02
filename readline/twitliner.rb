require 'readline'
require 'twitter'
require 'chronic'

CONSUMER_KEY =        "yjyqHNeu8EB3WLngq3E9GQ"
CONSUMER_SECRET =     "rzAu6jWbNuwof6lDv3b2HGqLj9WtgzWtJbD20YdjY"
OAUTH_TOKEN =         "14871281-Auzg5NHlwoogOAlE4lqeY23s61Mq43p6yqk1DWdGD"
OAUTH_TOKEN_SECRET =  "VeGsQeFnwcrdz4eKbN3b9uo40QQil4NMy07aV7ICb1Q"

PROMPT = '> '


Twitter.configure do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.oauth_token = OAUTH_TOKEN
  config.oauth_token_secret = OAUTH_TOKEN_SECRET
end

client = Twitter::Client.new

timeline = client.home_timeline
timeline.reverse_each do |tweet|
  date_string = Chronic.parse(tweet.created_at).strftime("%k:%M")
  print "#{date_string} <#{tweet.user.screen_name}> #{tweet.text}\n"
end

last_tweet_id = timeline.first.id if timeline
time_to_wait = 3
last_fetch = Time.now

stty_save = `stty -g`.chomp
trap('INT') { system('stty', stty_save); puts "\nThanks for Tweeting!"; exit }

Thread.new do
  loop do
   #if (Time.now - last_fetch).round(1) % 1 == 0
   #  print "Waiting #{(last_fetch + time_to_wait - Time.now).round} seconds" 
   #end
    if Time.now > last_fetch + time_to_wait
      line = Readline.line_buffer
      timeline = client.home_timeline( :since_id => last_tweet_id )
      if timeline.size > 0
        timeline.reverse_each do |tweet|
          date_string = Chronic.parse(tweet.created_at).strftime("%k:%M")
          print "#{date_string} <#{tweet.user.screen_name}> #{tweet.text}\n"
        end
        last_tweet_id = timeline.first.id
        print "#{PROMPT}#{line}"
      end
      last_fetch = Time.now
    end
  end
end
loop do
  line = Readline.readline(PROMPT, true)
  p line if line
end
