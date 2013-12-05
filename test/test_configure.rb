require 'minitest/unit'
require 'minitest/autorun'
require './lib/wa2bot.rb'

class TestConfigure < MiniTest::Unit::TestCase
  def test_load_token
    tokens = Wa2Bot::Configure.load_token
    assert_equal(
      tokens.keys,
      %w(consumer_key consumer_secret access_token access_token_secret)
    )
  end

  def test_load_posts
    posts = Wa2Bot::Configure.load_posts
    assert_equal(
      {"char" => "北原春希", "post" => "一番、大切なひとだけを救おうって、そう、決めたんだ"},
      posts[0]
    )
  end
end
