module Wa2Bot
  module Search
    SEARCH_KEYWORDS = ['#wa2', '#wa2anime']
    HISTORY_LENGTH = 60
    RT_HISTORY_LENGTH = 10
    HISTORY_FILE = './log/history.yml'
    RETWEET_FILE = './log/retweet.yml'

    @@retweeted_ids = []

    module_function

    # execute search by using twitter api
    def search
      tweets = Wa2Bot::Bot.instance.search SEARCH_KEYWORDS.sample

      tweets.flatten.map {|tweet|
        {
          id: tweet.id,
          favorite_count: tweet.favorite_count,
          retweet_count: tweet.retweet_count,
          username: tweet.user[:name],
          text: tweet.text.gsub(/RT @\w+:\s*|#.+/, '').strip.chomp
        }
      }
    end

    def load_searched_tweets
      (File.exist? HISTORY_FILE) ? YAML.load_file(HISTORY_FILE) : []
    end

    def load_retweet_id
      (File.exist? RETWEET_FILE) ? YAML.load_file(RETWEET_FILE) : []
    end

    def save_searched_tweets(source=nil)
      new_tweets = search
      old_tweets = load_searched_tweets
      tweets = sort_tweets_by_fav_and_rt_count(
        remove_duplication(old_tweets + new_tweets))

      if (tweets.length > HISTORY_LENGTH)
        # slice from last index by HISTORY_LENGTH
        tweets = tweets[-HISTORY_LENGTH, HISTORY_LENGTH]
      end

      # write to history file
      File.open(HISTORY_FILE, 'w') {|file| YAML.dump(tweets, file)}
    end

    def save_retweet_id(ids)
      if ids.length > RT_HISTORY_LENGTH
        ids = ids[-RT_HISTORY_LENGTH, RT_HISTORY_LENGTH]
      end
      File.open(RETWEET_FILE, 'w') {|file| YAML.dump(ids, file)}
    end

    def get_most_priority_tweet
      tweets = load_searched_tweets
      ids = load_retweet_id
      tweets.each do |tweet|
        # check this tweet is retweeted before
        unless ids.include? tweet[:id]
          ids << tweet[:id]
          save_retweet_id ids
          return tweet
        end
      end
      tweets.sample
    end

    def remove_duplication(tweets)
      texts = []
      ids = []
      unique_tweets = []
      tweets.each do |tweet|
        unless texts.include?(tweet[:text]) or ids.include?(tweet[:id])
          texts << tweet[:text]
          ids << tweet[:id]
          unique_tweets << tweet
        end
      end

      unique_tweets
    end

    def sort_tweets_by_fav_and_rt_count(tweets)
      return tweets.sort {|a, b|
        asum = a[:favorite_count] + a[:retweet_count]
        bsum = b[:favorite_count] + b[:retweet_count]
        bsum <=> asum
      }
    end
  end
end
