require 'minitest/autorun'
require './lib/wa2bot'

class TestSearch < Minitest::Test
  def test_search
    results = Wa2Bot::Search.search
    results.each do |tweet|
      assert_equal(
        tweet.keys,
        %i(id favorite_count retweet_count username text)
      )
    end
  end

  def test_load_searched_tweets_found
    File.write Wa2Bot::Search::HISTORY_FILE, "test: test"
    assert_equal Wa2Bot::Search.load_searched_tweets, {'test' => 'test'}
  end

  def test_load_searched_tweets_not_found
    File.stub(:exist?, false) do
      assert_equal Wa2Bot::Search.load_searched_tweets, []
    end
  end

  def test_get_most_priority_tweet
  end

  def test_remove_duplication
    tweets = [
      {id: 1, text: "a"},
      {id: 2, text: "b"},
      {id: 3, text: "b"}
    ]
    assert_equal(
      Wa2Bot::Search.remove_duplication(tweets),
      [{id: 1, text: "a"}, {id: 2, text: "b"}]
    )
  end
end
