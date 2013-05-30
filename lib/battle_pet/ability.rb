class BattlePet::Ability
  attr_accessor :id, :name, :type, :cooldown, :rounds

  def initialize(params)
    @id = params["id"]
    @name = params["name"]
    @type = BattlePet::Type.find(params["petTypeId"])
    @cooldown = params["cooldown"]
    @rounds = params["rounds"]
  end
end
