require 'minitest/unit'
require 'minitest/autorun'
require './lib/wa2bot/character.rb'

class TestCharacter < MiniTest::Unit::TestCase
  def test_initialize_unknown
    char = Wa2Bot::Character.new 'someone'

    assert_equal char.firstname, 'someone'
    assert_equal char.lastname, 'someone'
    assert_equal char.fullname, 'someone'
    assert Wa2Bot::Character::ICONS[:defalut].include? char.icon
  end

  def test_initialize_setsuna
    char = Wa2Bot::Character.new '小木曽雪菜'

    assert_equal char.firstname, '小木曽'
    assert_equal char.lastname, '雪菜'
    assert_equal char.fullname, '小木曽雪菜'
    assert Wa2Bot::Character::ICONS[:setsuna].include? char.icon
  end

  def test_initialize_haruki
    char = Wa2Bot::Character.new '春希'

    assert_equal char.firstname, '北原'
    assert_equal char.lastname, '春希'
    assert_equal char.fullname, '北原春希'
    assert Wa2Bot::Character::ICONS[:haruki].include? char.icon
  end

  def test_initialize_takeya
    char = Wa2Bot::Character.new '武也'
    assert_equal char.firstname, '飯塚'
    assert Wa2Bot::Character::ICONS[:takeya].include? char.icon
  end

  def test_initialize_no_icon
    char = Wa2Bot::Character.new '朋'

    assert_equal char.firstname, '柳原'
    assert_equal char.lastname, '朋'
    assert_equal char.fullname, '柳原朋'
    assert Wa2Bot::Character::ICONS[:defalut].include? char.icon
  end
end
