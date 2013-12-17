require 'twitter'
require 'singleton'
require 'logger'

module Wa2Bot
  class Bot
    include Singleton

    def initialize
      tokens = Wa2Bot::Configure.load_token
      @client = Twitter::REST::Client.new(
        consumer_key: tokens['consumer_key'],
        consumer_secret: tokens['consumer_secret'],
        oauth_token: tokens['access_token'],
        oauth_token_secret: tokens['access_token_secret'])

      @posts = Wa2Bot::Configure.load_posts.map {|obj| Post.new(obj)}
      @log = Logger.new(STDOUT)
      @log.level = Logger::INFO
    end

    def tweet
      icon, message = @posts.sample.convert_to_tweet
      call_twitter_api do
        update_profile_image File.new(icon)
        update message
      end
    end

    def retweet
      target_tweet = Wa2Bot::Search.get_most_priority_tweet
      call_twitter_api do
        retweet target_tweet[:id]
      end
    end

    def update_searchresult
      Wa2Bot::Search.save_searched_tweets
    end

    def search(query)
      call_twitter_api do
        search(query, {lang: 'ja', result_type: 'mixed'})
      end
    end

    def update_follower
      followers, frineds = [], []
      call_twitter_api do
        followers = follower_ids.all # followers
        frineds = friend_ids.all # following
      end

      # Unfollow
      (frineds - followers)[0, 5].each do |id|
        call_twitter_api {unfollow id}
      end
      # Follow
      (followers - frineds)[0, 5].each do |id|
        call_twitter_api {follow id}
      end
    end

    private

    def call_twitter_api(&block)
      @client.instance_eval(&block)
    rescue Timeout::Error => timeout
      @log.error "Timeout error: #{timeout.message} retry..."
      sleep 2
      retry
    rescue Twitter::Error => twitter
      @log.error "Twitter error: #{twitter.message} retry..."
      sleep 2
      retry
    rescue => error
      @log.error error
    end
  end
end
