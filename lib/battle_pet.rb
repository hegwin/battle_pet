require 'open-uri'
require 'json'

class BattlePet
  attr_accessor :description

  def initialize(id)
    url = "http://www.battlenet.com.cn/api/wow/battlePet/species/" + id.to_s
    info = JSON.parse(open(url).read)
    @description = info["description"]
  end
end
