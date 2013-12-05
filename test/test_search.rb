require 'minitest/unit'
require 'minitest/autorun'
require './lib/wa2bot.rb'

class TestSearch < MiniTest::Unit::TestCase
  def setup
    @tweets
  end

  def test_search
    results = Wa2Bot::Search.search
    results.each do |tweet|
      assert_equal(
        tweet.keys,
        %i(id favorite_count retweet_count username text)
      )
    end
  end
end
