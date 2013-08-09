require 'twitter'
require 'singleton'

require './post'
require './configure'
require './character'


module Wa2Bot
  class Bot
    include Singleton

    def initialize
      if File.exist? Wa2Bot::Configure::TOKEN_FILE
        # When token.yml file exist, load oauth keys from it.
        tokens = Wa2Bot::Configure.load_token
        @client = Twitter::Client.new(
          consumer_key: tokens['consumer_key'],
          consumer_secret: tokens['consumer_secret'],
          oauth_token: tokens['access_token'],
          oauth_token_secret: tokens['access_token_secret'])
      else
        @client = Twitter::Client.new(
          consumer_key: ENV['CONSUMER_KEY'],
          consumer_secret: ENV['CONSUMER_SECRET'],
          oauth_token: ENV['ACCESS_TOKEN'],
          oauth_token_secret: ENV['ACCESS_TOKEN_SECRET'])
      end

      @posts = Wa2Bot::Configure.load_posts.map {|obj| Post.new(obj)}
    end

    def search_wa2
      keywords = ['#wa2', "#whitealbum2", "ホワイトアルバム２"]
      results = []
      keywords.each do |query|
        results << @client.search(query, {lang: 'ja'}).results
      end
      return results.flatten
    end

    def select_popular_tweet(tweets)
      tweets.sort! {|a, b|
        asum = a.favorite_count + a.retweet_count
        bsum = b.favorite_count + b.retweet_count
        bsum <=> asum
      }

      ids = Wa2Bot::Configure.load_retweeted_ids
      tweets.each do |tweet|
        return tweet.id unless ids.include?(tweet.id)
      end
    end

    def retweet
      # @client.update_profile_image File.new(Wa2Bot::Character::ICONS[:defalut])
      target_id = select_popular_tweet search_wa2
      # Save retweet id
      Wa2Bot::Configure.save_retweeted_id target_id
      @client.retweet target_id
    end

    def tweet
      icon, message = @posts.sample.convert_to_tweet
      @client.update_profile_image File.new(icon)
      @client.update message
    end

    def update_follower
      followers = @client.follower_ids.all # followers
      frineds = @client.friend_ids.all # following

      # Unfollow
      (frineds - followers)[0, 10].each {|id| @client.unfollow id}
      # Follow
      (followers - frineds)[0, 10].each {|id| @client.follow id}
    end
  end
end
