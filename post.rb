module Wa2Bot
  class Post
    attr_accessor :char, :content

    def initialize(obj)
      @char = Wa2Bot::Character.new obj['char']
      @content = obj['post']
    end

    # return icon image and tweet text
    def convert_to_tweet
      message = "「#{@content.gsub("\n", " ")}」"

      # When do not have a unique icon, add character name
      if @char.icon == Wa2Bot::Character::ICONS[:defalut]
        message = @char.lastname + message
      end

      return @char.icon, message
    end
  end
end
