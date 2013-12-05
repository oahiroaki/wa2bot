require 'yaml'

module Wa2Bot
  module Configure
    TOKEN_FILE = './conf/token.yml'
    POST_FILE = './conf/posts.yml'
    RETWEETED_FILE = './conf/retweet.yml'
    RETWEET_CACHE_NUM = 10

    module_function

    def load_token
      if File.exist? TOKEN_FILE
        YAML.load_file TOKEN_FILE
      elsif ENV[CONSUMER_KEY]
        {
          'consumer_key' => ENV['CONSUMER_KEY'],
          'consumer_secret' => ENV['CONSUMER_SECRET'],
          'access_token' => ENV['ACCESS_TOKEN'],
          'access_token_secret' => ENV['ACCESS_TOKEN_SECRET']
        }
      else
        raise "Token does not found"
      end
    end

    def load_posts
      if File.exist? POST_FILE
        return YAML.load_file POST_FILE
      else
        raise "Posts file does not found"
      end
    end

    def load_retweeted_ids
      unless File.exist? RETWEETED_FILE
        File.write RETWEETED_FILE, ""
      end
      YAML.load_file RETWEETED_FILE
    end

    def save_retweeted_id(id)
      temp = load_retweeted_ids + [id]
      temp.shift if temp.length > RETWEET_CACHE_NUM
      File.open(RETWEETED_FILE, 'w') {|f| YAML.dump(temp, f)}
    end
  end
end
