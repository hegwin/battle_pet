require 'open-uri'
require 'json'
require 'yaml'

class BattlePet
  attr_accessor :id, :name, :description, :source, :type, :creature

  REGION_HOSTS = { us: 'us.battle.net',
                   eu: 'eu.battle.net',
                   kr: 'kr.battle.net',
                   tw: 'tw.battle.net',
                   cn: 'www.battlenet.com.cn'}

  PET_NAMES = YAML.load File.read(File.join(File.dirname(__FILE__), 'battle_pet.yml'))

  PET_TYPES = { 0 => 'Humanoid',
                1 => 'Dragonkin',
                2 => 'Flying',
                3 => 'Undead',
                4 => 'Critter',
                5 => 'Magical',
                6 => 'Elemental',
                7 => 'Beast',
                8 => 'Aquatic',
                9 => 'Mechanical' }
  
  def initialize(id, locale = :us)
    url = "http://#{host(locale)}/api/wow/battlePet/species/#{id.to_s}"
    info = JSON.parse(open(url).read)
    @id = id
    @description = info["description"]
    @name = find_name(locale)
    @source = info["source"]
    @can_battle = info["canBattle"]
    @type = pet_type info["petTypeId"]
    @creature = info["creatureId"]
  end

  def can_battle?
    @can_battle
  end

  protected

  def host(locale)
    REGION_HOSTS[locale] || REGION_HOSTS[:us]
  end
  
  def find_name(locale)
    PET_NAMES[id] && PET_NAMES[id]["name"][locale.to_s]
  end

  def pet_type(type_id)
    PET_TYPES[type_id]
  end
end
