module Wa2Bot
  module Search
    SEARCH_KEYWORDS = ['#wa2', '#wa2anime']
    HISTORY_LENGTH = 60
    HISTORY_FILE = 'history.yml'
    RETWEET_FILE = 'retweet.yml'

    @@keyword_index = 0
    @@retweeted_ids = []

    module_function

    def search
      tweets = Wa2Bot::Bot.instance.search SEARCH_KEYWORDS[@@keyword_index]

      update_keyword_index

      return tweets.flatten.map {|tweet|
        {
          id: tweet.id,
          favorite_count: tweet.favorite_count,
          retweet_count: tweet.retweet_count,
          username: tweet.user[:name],
          text: tweet.text.gsub(/RT @\w+:\s*|#.+/, '').strip.chomp
        }
      }
    end

    def update_keyword_index
      @@keyword_index += 1
      if @@keyword_index > SEARCH_KEYWORDS.length - 1
        @@keyword_index = 0
      end
      return @@keyword_index
    end

    def load_searched_tweets
      return (File.exist? HISTORY_FILE) ? YAML.load_file(HISTORY_FILE) : []
    end

    def write_history_file(tweets)
      File.open(HISTORY_FILE, 'w') {|file| YAML.dump(tweets, file)}
    end

    def save_searched_tweets
      new_tweets = search
      old_tweets = load_searched_tweets

      tweets = sort_tweets_by_fav_and_rt_count(
        remove_duplication(old_tweets + new_tweets))

      if (tweets.length > HISTORY_LENGTH)
        tweets = tweets[-HISTORY_LENGTH, HISTORY_LENGTH]
      end

      write_history_file tweets
    end

    def get_most_priority_tweet
      tweets = load_searched_tweets
      ids = load_retweet_id
      tweets.each do |tweet|
        unless ids.include? tweet[:id]
          ids << tweet[:id]
          write_retweet_id ids
          return tweet
        end
      end
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

      return unique_tweets
    end

    def write_retweet_id(ids)
      ids = ids[-10, 10] if ids.length > 10
      File.open(RETWEET_FILE, 'w') {|file| YAML.dump(ids, file)}
    end

    def load_retweet_id
      return (File.exist? RETWEET_FILE) ? YAML.load_file(RETWEET_FILE) : []
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
