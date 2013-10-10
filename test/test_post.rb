require 'minitest/unit'
require 'minitest/autorun'
require './lib/wa2bot.rb'

class TestPost < MiniTest::Unit::TestCase
  def test_initialize
    post = Wa2Bot::Post.new({
      'char' => '北原春希',
      'post' => '一番、大切なひとだけを救おうって、そう、決めたんだ'})

    assert_equal post.char.firstname, '北原'
    assert_equal post.char.lastname, '春希'

    assert_equal(
      post.content,
      '一番、大切なひとだけを救おうって、そう、決めたんだ')
  end

  def test_convert_to_tweet_with_icon
    post = Wa2Bot::Post.new({
      'char' => '小木曽雪菜',
      'post' => "あと五分でいい…\nこれから五分間にわたしの言うことだけは、永遠に、忘れて！"})

    icon, message = post.convert_to_tweet
    assert_equal icon, Wa2Bot::Character::ICONS[:setsuna]
    assert_equal(
      message,
      "「あと五分でいい… これから五分間にわたしの言うことだけは、永遠に、忘れて！」")
  end

  def test_convert_to_tweet_with_noicon
    post = Wa2Bot::Post.new({
      'char' => '柳原朋',
      'post' => "test message"})

    icon, message = post.convert_to_tweet
    assert_equal icon, Wa2Bot::Character::ICONS[:defalut]

    assert_equal message, "朋「test message」"
  end
end
