require 'open-uri'
require 'json'
require 'yaml'

class BattlePet
  attr_accessor :id, :description, :name

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
    @name = get_name(locale)
  end

  protected

  def host(locale)
    REGION_HOSTS[locale] || REGION_HOSTS[:us]
  end
  
  def get_name(locale)
    PET_NAMES[id] && PET_NAMES[id]["name"][locale.to_s]
  end
end
