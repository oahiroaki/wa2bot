require 'minitest/autorun'

class TestConfigure < Minitest::Test
  def test_load_token_found
    tokens = Wa2Bot::Configure.load_token
    assert_equal(
      tokens.keys,
      %w(consumer_key consumer_secret access_token access_token_secret)
    )
  end

  def test_load_token_not_found
    File.stub(:exist?, false) do
      assert_raises(RuntimeError) {Wa2Bot::Configure.load_token}
    end
  end

  def test_load_posts_found
    posts = Wa2Bot::Configure.load_posts
    assert_equal(
      {"char" => "北原春希", "post" => "一番、大切なひとだけを救おうって、そう、決めたんだ"},
      posts[0]
    )
  end

  def test_load_posts_not_found
    File.stub(:exist?, false) do
      assert_raises(RuntimeError) {Wa2Bot::Configure.load_posts}
    end
  end
end
