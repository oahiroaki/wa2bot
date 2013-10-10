require 'yaml'

module Wa2Bot
  module Configure
    TOKEN_FILE = './ext/token.yml'
    POST_FILE = './ext/posts.yml'
    RETWEETED_FILE = './ext/retweet.yml'
    RETWEET_CACHE_NUM = 10

    module_function

    def load_token
      if File.exist? TOKEN_FILE
        return YAML.load_file(TOKEN_FILE)
      else
        raise "Token file does not found"
      end
    end

    def load_posts
      if File.exist? POST_FILE
        return YAML.load_file(POST_FILE)
      else
        raise "Posts file does not found"
      end
    end

    def load_retweeted_ids
      unless File.exist? RETWEETED_FILE
        File.write(RETWEETED_FILE, "")
      end
      return YAML.load_file(RETWEETED_FILE)
    end

    def save_retweeted_id(id)
      temp = load_retweeted_ids + [id]
      temp.shift if temp.length > RETWEET_CACHE_NUM
      File.open(RETWEETED_FILE, 'w') {|f| YAML.dump(temp, f)}
    end
  end
end
