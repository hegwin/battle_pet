require 'open-uri'
require 'json'
require 'yaml'

class BattlePet
  attr_accessor :id, :name, :description, :source, :type, :creature, :abilities, :added_in_patch

  REGION_HOSTS = { us: 'us.battle.net',
                   eu: 'eu.battle.net',
                   kr: 'kr.battle.net',
                   tw: 'tw.battle.net',
                   cn: 'www.battlenet.com.cn' }

  def initialize(id, locale = :us)
    data = BattlePet.parse_data_from_api(id, locale)
    set_attributes(data, locale)
  end

  def can_battle?
    @can_battle
  end

  protected
  
  def self.parse_data_from_api(id, locale)
    url = "http://#{host(locale)}/api/wow/battlePet/species/#{id.to_s}"
    JSON.parse(open(url).read)
  end
  
  def set_attributes(data, locale)
    @id = data["speciesId"]
    @name = data["name"]
    @description = data["description"]
    @source = BattlePet.parse_source data["source"], locale
    @can_battle = data["canBattle"]
    @type = Type.find data["petTypeId"]
    @creature = data["creatureId"]
    @added_in_patch = BattlePet.check_patch(id)
    @abilities = acquire_abilities data["abilities"]
  end

  def self.host(locale)
    REGION_HOSTS[locale] || REGION_HOSTS[:us]
  end
  
  def acquire_abilities(abilities)
    results = {}
    abilities.each { |ability| results[ability['requiredLevel']] = Ability.new(ability) }
    results
  end
  
  def self.check_patch(id)
    case id
    when 1..864     then '5.0'
    when 865..1013  then '5.1'
    when 1014..1213 then '5.2'
    else                 '5.3' 
    end
  end

  def self.parse_source(str_source, locale)
    translator = Translator.new(locale)
    hash_source = {}
    str_source.split(/\n+/).each do |line|
      match_data = line.match(translator.colon) 
      k = match_data.pre_match
      v = match_data.post_match.gsub(/\(\d+\)/, '').strip
      v = parse_cost(v) if k == translator.cost
      hash_source[k] = v
    end
    hash_source
  end

  def self.parse_cost(str_cost)
    num = str_cost.match(/^\d*/).to_s
    unit = case str_cost
           when /GOLDICON/   then 'G'
           when /SILVERICON/ then 'S'
           else              ''
           end
    num + unit
  end
end

require 'battle_pet/type'
require 'battle_pet/ability'
require 'battle_pet/translator'
