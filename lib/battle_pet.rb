require 'open-uri'
require 'json'
require 'yaml'

class BattlePet
  attr_accessor :id, :name, :description, :source, :type, :creature, :abilities, :added_in_patch, :icon

  REGION_HOSTS = { us: 'us.battle.net',
                   eu: 'eu.battle.net',
                   kr: 'kr.battle.net',
                   tw: 'tw.battle.net',
                   cn: 'www.battlenet.com.cn' }

  def initialize(id, locale = :us)
    data = BattlePet.parse_data_from_api(id, locale)
    set_attributes(data, locale) if data
  end

  def can_battle?
    @can_battle
  end

  def icon_url
    "http://media.blizzard.com/wow/icons/56/#{icon}.jpg"
  end

  protected
  
  def self.parse_data_from_api(id, locale)
    url = "http://#{host(locale)}/api/wow/battlePet/species/#{id.to_s}"
    tried_times = 0
    begin
      response = open(url)
    rescue OpenURI::HTTPError => e
      if e.message =~ /404/
        warn '[WARNING] Pet ID Incorrect'
      elsif e.message =~ /500/
        warn '[WARNING] Access denied.'
      elsif tried_times < 3
        tried_times += 1
        retry
      end
    end
    response ? JSON.parse(response.read) : nil
  end
  
  def set_attributes(data, locale)
    @id = data["speciesId"]
    @name = data["name"]
    @description = data["description"]
    @icon = data["icon"]
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
    when 1226..1248, 1184, 1200, 1205 then '5.3'
    when 1174..1213                   then '5.2'
    when 868..1168                    then '5.1'
    when 1..864                       then '5.0'
    else                                   'unknown'
    end
  end

  def self.parse_source(str_source, locale)
    translator = Translator.new(locale)
    hash_source = {}
    str_source.split(/\n+/).each do |line|
      if match_data = line.match(translator.colon) 
        k = match_data.pre_match
        v = match_data.post_match.gsub(/\(\d+\)/, '').strip
        v = parse_cost(v) if k == translator.cost
      else
        k = line
        v = ""
      end
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
