require 'open-uri'
require 'json'
require 'yaml'

require_relative 'pet_type.rb'
require_relative 'pet_ability.rb'

class BattlePet
  attr_accessor :id, :name, :description, :source, :type, :creature, :abilities, :added_in_patch

  REGION_HOSTS = { us: 'us.battle.net',
                   eu: 'eu.battle.net',
                   kr: 'kr.battle.net',
                   tw: 'tw.battle.net',
                   cn: 'www.battlenet.com.cn'}

  PET_NAMES = YAML.load File.read(File.join(File.dirname(__FILE__), 'battle_pet.yml'))
  
  def initialize(id, locale = :us)
    info = get_data_from_api(id, locale)
    set_attributes(info, locale)    
  end

  def can_battle?
    @can_battle
  end

  protected
  
  def get_data_from_api(id, locale)
    url = "http://#{host(locale)}/api/wow/battlePet/species/#{id.to_s}"
    JSON.parse(open(url).read)
  end
  
  def set_attributes(hash, locale)
    @id = hash["speciesId"]
    @description = hash["description"]
    @name = find_name(locale)
    @source = hash["source"]
    @can_battle = hash["canBattle"]
    @type = PetType.find hash["petTypeId"]
    @creature = hash["creatureId"]
    @abilities = acquire_abilities hash["abilities"]
    @added_in_patch = check_patch
  end

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
  
  def check_patch
    case @id
    when 1..864     then '5.0'
    when 865..1013  then '5.1'
    when 1014..1213 then '5.2'
    else                 '5.3' 
    end
  end
end
