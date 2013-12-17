require 'minitest/autorun'

class TestPost < Minitest::Test
  def test_convert_to_tweet_with_icon
    post = Wa2Bot::Post.new({
      'char' => '小木曽雪菜',
      'post' => "あと五分でいい…\nこれから五分間にわたしの言うことだけは、永遠に、忘れて！"})

    icon, message = post.convert_to_tweet
    assert Wa2Bot::Character::ICONS[:setsuna].include? icon
    assert_equal(
      message,
      "あと五分でいい… これから五分間にわたしの言うことだけは、永遠に、忘れて！"
    )
  end

  def test_convert_to_tweet_with_noicon
    post = Wa2Bot::Post.new({
      'char' => '柳原朋',
      'post' => "test message"})

    icon, message = post.convert_to_tweet
    assert Wa2Bot::Character::ICONS[:defalut].include? icon
    assert_equal message, "朋: test message"
  end
end
