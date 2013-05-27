require 'open-uri'
require 'json'
require 'yaml'

require_relative 'pet_type.rb'
require_relative 'pet_ability.rb'

class BattlePet
  attr_accessor :id, :name, :description, :source, :type, :creature, :abilities

  REGION_HOSTS = { us: 'us.battle.net',
                   eu: 'eu.battle.net',
                   kr: 'kr.battle.net',
                   tw: 'tw.battle.net',
                   cn: 'www.battlenet.com.cn'}

  PET_NAMES = YAML.load File.read(File.join(File.dirname(__FILE__), 'battle_pet.yml'))
  
  def initialize(id, locale = :us)
    url = "http://#{host(locale)}/api/wow/battlePet/species/#{id.to_s}"
    info = JSON.parse(open(url).read)
    @id = id
    @description = info["description"]
    @name = find_name(locale)
    @source = info["source"]
    @can_battle = info["canBattle"]
    @type = PetType.find info["petTypeId"]
    @creature = info["creatureId"]
    @abilities = acquire_abilities info["abilities"]
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

  def acquire_abilities(abilities)
    results = {}
    abilities.each { |ability| results[ability['requiredLevel']] = PetAbility.new(ability) }
    results
  end
end
