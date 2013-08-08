require 'minitest/unit'
require 'minitest/autorun'
require './character'

class TestCharacter < MiniTest::Unit::TestCase
  def test_initialize_unknown
    char = Wa2Bot::Character.new 'someone'

    assert_equal char.firstname, ''
    assert_equal char.lastname, ''
    assert_equal char.fullname, 'someone'
    assert_equal char.icon, Wa2Bot::Character::ICONS[:defalut]
  end

  def test_initialize_has_icon
    char = Wa2Bot::Character.new '小木曽雪菜'

    assert_equal char.firstname, '小木曽'
    assert_equal char.lastname, '雪菜'
    assert_equal char.fullname, '小木曽雪菜'
    assert_equal char.icon, Wa2Bot::Character::ICONS[:setsuna]
  end

  def test_initialize_no_icon
    char = Wa2Bot::Character.new '春希'

    assert_equal char.firstname, '北原'
    assert_equal char.lastname, '春希'
    assert_equal char.fullname, '北原春希'
    assert_equal char.icon, Wa2Bot::Character::ICONS[:defalut]
  end
end
