# encoding: utf-8
require 'test/unit'
require 'battle_pet'

class BattlePetTest < Test::Unit::TestCase
  
  def test_parse_data_from_api
    assert_equal JSON.parse(File.read(File.join(File.dirname(__FILE__), 'data/mechanical_squirrel_us.json'))),
                 BattlePet.parse_data_from_api(39, :us)
  end

  def test_host
    assert_equal 'us.battle.net', BattlePet.host(:us)
    assert_equal 'www.battlenet.com.cn', BattlePet.host(:cn)
    assert_equal 'us.battle.net', BattlePet.host(:ca)
  end

  def test_find_name
    assert_equal '机械松鼠', BattlePet.find_name(39, :cn)
    assert_equal 'Adder', BattlePet.find_name(635, :us)
    assert_equal nil, BattlePet.find_name(1, :cn)
    assert_equal nil, BattlePet.find_name(39, :ca)
  end

  def test_check_patch
    (1..864).to_a.sample(5) { |i| assert_equal '5.0', BattlePet.check_patch(i) }
    (865..1013).to_a.sample(5) { |i| assert_equal '5.1', BattlePet.check_patch(i) }
    (1014..1213).to_a.sample(5) { |i| assert_equal '5.2', BattlePet.check_patch(i) }
    (1213..1400).to_a.sample(5) { |i| assert_equal '5.3', BattlePet.check_patch(i) }
  end

end
