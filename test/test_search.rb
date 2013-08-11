require 'minitest/unit'
require 'minitest/autorun'
require './bot'

class TestSearch < MiniTest::Unit::TestCase
  def test_search
  end

  def test_update_keyword_index
    r = Wa2Bot::Search.update_keyword_index
    assert_equal r, 1

    r = Wa2Bot::Search.update_keyword_index
    assert_equal r, 0
  end

  def test_load_and_write_tweets
    writedata = [{
      id: 1,
      favorite_count: 1,
      retweet_count: 1,
      username: 'user1',
      text: 'text1'
    }, {
      id: 2,
      favorite_count: 1,
      retweet_count: 1,
      username: 'user2',
      text: 'text2'
    }]

    Wa2Bot::Search.write_history_file(writedata)
    data = Wa2Bot::Search.load_searched_tweets
    assert_equal writedata, data
  end

  def test_remove_duplication
    tweets = [{
      id: 1,
      favorite_count: 1,
      retweet_count: 1,
      username: 'user1',
      text: 'text'
    }, {
      id: 2,
      favorite_count: 1,
      retweet_count: 1,
      username: 'user2',
      text: 'text'
    }, {
      id: 3,
      favorite_count: 1,
      retweet_count: 10,
      username: 'user3',
      text: 'text1'
    }]

    results = [{
      id: 1,
      favorite_count: 1,
      retweet_count: 1,
      username: 'user1',
      text: 'text'
    }, {
      id: 3,
      favorite_count: 1,
      retweet_count: 10,
      username: 'user3',
      text: 'text1'
    }]

    unique = Wa2Bot::Search.remove_duplication tweets

    assert_equal unique, results
  end

  def test_sort_tweets_by_fav_and_rt_count
    source = Array.new(20) {|i|
      {
        id: i, favorite_count: i,
        retweet_count: i,
        username: "user#{i}",
        text: "text#{i}"
      }
    }

    assert_equal(
      source.reverse,
      Wa2Bot::Search.sort_tweets_by_fav_and_rt_count(source)
    )
  end

  def test_save_searched_tweets
    source = Array.new(70) {|i|
      {
        id: i, favorite_count: i,
        retweet_count: i,
        username: "user#{i}",
        text: "text#{i}"
      }
    }

    Wa2Bot::Search.save_searched_tweets source

    loaded = Wa2Bot::Search.load_searched_tweets

    assert_equal loaded.length, Wa2Bot::Search::HISTORY_LENGTH
  end

  def test_get_most_priority_tweet
    source = Array.new(70) {|i|
      {
        id: i, favorite_count: i,
        retweet_count: i,
        username: "user#{i}",
        text: "text#{i}"
      }
    }

    Wa2Bot::Search.save_searched_tweets source

    tweet = Wa2Bot::Search.get_most_priority_tweet
    loaded = Wa2Bot::Search.load_searched_tweets
    assert_equal tweet[:id], 69
    assert_equal loaded.length, Wa2Bot::Search::HISTORY_LENGTH - 1
  end
end
