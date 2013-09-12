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
  when 'update' then Wa2Bot::Bot.instance.update_searchresult
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

# 検索結果の更新
every(1.hour, 'update', at: ['10:30', '14:30', '18:30', '22:30', '2:30'])

# たまにリツィート
every(1.hour, 'retweet', at: ['12:30', '22:30'])

every(1.hour, 'follow', at: '3:30')
