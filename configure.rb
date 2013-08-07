require 'yaml'

module Wa2Bot
  module Configure
    TOKEN_FILE = 'token.yml'
    POST_FILE = 'posts.yml'
    RETWEETED_FILE = 'retweeted.yml'

    module_function

    def load_token
      return YAML.load_file(TOKEN_FILE)
    end

    def load_posts
      return YAML.load_file(POST_FILE)
    end

    def load_retweeted_ids
      loaded = YAML.load_file(RETWEETED_FILE)
      return (loaded) ? loaded : []
    end

    def save_retweeted_id(id)
      temp = load_retweeted_ids + [id]
      temp.shift if temp.length > 10
      File.open(RETWEETED_FILE, 'w') {|f| YAML.dump(temp, f)}
    end
  end
end
