require 'twitter'
require 'singleton'

require './post'
require './configure'
require './character'
require './diff'
require './search'

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

    def tweet
      icon, message = @posts.sample.convert_to_tweet
      @client.update_profile_image File.new(icon)
      @client.update message
    end

    def retweet
      target_tweet = Wa2Bot::Search.get_most_priority_tweet
      @client.retweet target_tweet[:id]
    end

    def update_searchresult
      Wa2Bot::Search.save_searched_tweets
    end

    def search(query)
      return @client.search(query, {lang: 'ja'}).results
    end

    def update_follower
      followers = @client.follower_ids.all # followers
      frineds = @client.friend_ids.all # following

      # Unfollow
      (frineds - followers)[0, 5].each {|id| @client.unfollow id}
      # Follow
      (followers - frineds)[0, 5].each {|id| @client.follow id}
    end
  end
end
