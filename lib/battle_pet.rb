require 'open-uri'
require 'json'

class BattlePet
  attr_accessor :description

  REGION_HOSTS = { us: 'us.battle.net',
                   eu: 'eu.battle.net',
                   kr: 'kr.battle.net',
                   tw: 'tw.battle.net',
                   cn: 'www.battlenet.com.cn'}

  def initialize(id, locale = :us)
    url = "http://#{host(locale)}/api/wow/battlePet/species/#{id.to_s}"
    info = JSON.parse(open(url).read)
    @description = info["description"]
  end

  protected

  def host(locale)
    REGION_HOSTS[locale] || REGION_HOSTS[:us]
  end
end
