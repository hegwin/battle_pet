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

  def test_check_patch
    (1..864).to_a.sample(5) { |i| assert_equal '5.0', BattlePet.check_patch(i) }
    (865..1013).to_a.sample(5) { |i| assert_equal '5.1', BattlePet.check_patch(i) }
    (1014..1213).to_a.sample(5) { |i| assert_equal '5.2', BattlePet.check_patch(i) }
    (1213..1400).to_a.sample(5) { |i| assert_equal '5.3', BattlePet.check_patch(i) }
  end

  def test_parse_source
    assert_equal({ "Quest" => "Egg Wave", "Zone" => "Mount Hyjal" }, BattlePet.parse_source("Quest: Egg Wave\n\nZone: Mount Hyjal\n\n\n\n", :us))
    assert_equal({ "Profession" => "Engineering" }, BattlePet.parse_source("Profession: Engineering", :us))
    assert_equal({ "Profession" => "Archaeology" }, BattlePet.parse_source("Profession: Archaeology", :us))
    assert_equal({ "Profession" => "Enchanting", "Formula" => "Enchanted Lantern" }, BattlePet.parse_source("Profession: Enchanting (525)\n\nFormula: Enchanted Lantern", :us))
    assert_equal({ "Achievement" => "Rock Lover", "Category" => "Quests" }, BattlePet.parse_source("Achievement: Rock Lover\n\nCategory: Quests", :us))
    assert_equal({ "Promotion" => "Cataclysm Collector's Edition" }, BattlePet.parse_source("Promotion: Cataclysm Collector's Edition", :us))
    assert_equal({ "Promotion" => "StarCraft II: Wings of Liberty Collector's Edition" }, BattlePet.parse_source("Promotion: StarCraft II: Wings of Liberty Collector's Edition", :us))
    assert_equal({ "Vendor" => "Guild Vendor", "Zone" => "Stormwind, Orgrimmar", "Cost" => "300G" }, BattlePet.parse_source("Vendor: Guild Vendor\n\nZone: Stormwind, Orgrimmar\n\nCost: 300TINTERFACE\\MONEYFRAME\\UI-GOLDICON.BLP:0\n\n", :us))
  end

  def test_parse_cost
    assert_equal "300G", BattlePet.parse_cost('300TINTERFACE\\MONEYFRAME\\UI-GOLDICON.BLP:0')
    assert_equal "50S", BattlePet.parse_cost('50TINTERFACE\\MONEYFRAME\\UI-SILVERICON.BLP:0')
    assert_equal "90", BattlePet.parse_cost('90 ')
  end

end
