require 'minitest/autorun'

class TestCharacter < Minitest::Test
  def test_initialize_unknown_name
    char = Wa2Bot::Character.new 'someone'
    assert_equal char.firstname, 'someone'
    assert_equal char.lastname, 'someone'
    assert_equal char.fullname, 'someone'
  end

  def test_initialize_unknown_icon
    char = Wa2Bot::Character.new 'unknown'
    assert Wa2Bot::Character::ICONS[:defalut].include? char.icon
  end

  def test_initialize_known_name
    char = Wa2Bot::Character.new '小木曽雪菜'
    assert_equal char.firstname, '小木曽'
    assert_equal char.lastname, '雪菜'
    assert_equal char.fullname, '小木曽雪菜'
  end

  def test_initialize_known_has_icon
    char = Wa2Bot::Character.new '小木曽雪菜'
    assert Wa2Bot::Character::ICONS[:setsuna].include? char.icon
  end

  def test_initialize_known_name_add
    char = Wa2Bot::Character.new '武也'
    assert_equal char.firstname, '飯塚'
  end

  def test_initialize_known_has_icon_add
    char = Wa2Bot::Character.new '武也'
    assert Wa2Bot::Character::ICONS[:takeya].include? char.icon
  end

  def test_initialize_known_no_icon
    char = Wa2Bot::Character.new '朋'
    assert Wa2Bot::Character::ICONS[:defalut].include? char.icon
  end
end
