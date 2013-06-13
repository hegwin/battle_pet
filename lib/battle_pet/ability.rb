class BattlePet::Ability
  attr_accessor :id, :name, :icon ,:type, :cooldown, :rounds

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @icon = data["icon"]
    @type = BattlePet::Type.find(data["petTypeId"])
    @cooldown = data["cooldown"]
    @rounds = data["rounds"]
  end

  def icon_url
    "http://media.blizzard.com/wow/icons/56/#{icon}.jpg"
  end
end
