module Wa2Bot
  class Post
    attr_accessor :id, :char, :content, :number

    def initialize(obj)
      @id = obj['id'].to_i
      @char = obj['char']
      @content = obj['post']
      @number = obj['num'].to_i || 0
    end
  end
end
