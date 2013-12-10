require 'yaml'

module Wa2Bot
  module Configure
    TOKEN_FILE = './conf/token.yml'
    POSTS_FILE = './conf/posts.yml'

    module_function

    def load_token
      if File.exist? TOKEN_FILE
        YAML.load_file TOKEN_FILE
      elsif ENV['CONSUMER_KEY']
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
      if File.exist? POSTS_FILE
        YAML.load_file POSTS_FILE
      else
        raise "Posts does not found"
      end
    end
  end
end
