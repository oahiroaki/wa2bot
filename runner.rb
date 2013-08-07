require 'clockwork'
require './bot'

include Clockwork

Clockwork.configure do |config|
  config[:tz] = 'Asia/Tokyo'
end

handler do |job|
  case job
  when 'tweet' then Wa2Bot::Bot.instance.tweet
  when 'retweet' then Wa2Bot::Bot.instance.retweet
  when 'follow' then Wa2Bot::Bot.instance.update_follower
  end
end

# 深夜帯以外一時間おきにツィート
every(
  1.hour,
  'tweet',
  if: lambda {|t|
    (t.hour >= 0 && t.hour <= 1) || (t.hour >= 5 && t.hour <= 23)
  }
)

# たまにリツィート
every(1.hour, 'retweet', at: ['12:30', '17:30', '22:30'])

every(1.hour, 'follow', at: '3:00')
