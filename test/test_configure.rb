require 'minitest/unit'
require 'minitest/autorun'
require './lib/wa2bot.rb'

class TestConfigure < MiniTest::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_load_token
    assert_raises(RuntimeError) {Wa2Bot::Configure.load_token}
  end

  def test_load_posts
    posts = Wa2Bot::Configure.load_posts
    assert_equal(
      {"char" => "北原春希", "post" => "一番、大切なひとだけを救おうって、そう、決めたんだ"},
      posts[0]
    )
  end
end
