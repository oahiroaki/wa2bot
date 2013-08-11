module Wa2Bot
  module Search
    SEARCH_KEYWORDS = ['#wa2', '#wa2anime']
    HISTORY_LENGTH = 60
    HISTORY_FILE = 'history.yml'

    @@keyword_index = 0

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
      return YAML.load_file(HISTORY_FILE)
    end

    def get_most_priority_tweet
      tweets = load_searched_tweets
      tweet = tweets.shift
      write_history_file tweets
      return tweet
    end

    def remove_duplication(tweets)
      texts = []
      unique_tweets = []
      tweets.each do |tweet|
        unless texts.include? tweet[:text]
          texts << tweet[:text]
          unique_tweets << tweet
        end
      end

      return unique_tweets
    end

    def get_all_tweets
      return remove_duplication(load_searched_tweets + search)
    end

    def write_history_file(tweets)
      File.open(HISTORY_FILE, 'w') {|file| YAML.dump(tweets, file)}
    end

    def save_searched_tweets(tweets)
      if (tweets.length > HISTORY_LENGTH)
        new_tweets = tweets[-HISTORY_LENGTH, HISTORY_LENGTH]
      else
        new_tweets = tweets
      end

      write_history_file sort_tweets_by_fav_and_rt_count(new_tweets)
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
