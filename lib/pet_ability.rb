class PetAbility
  attr_accessor :id, :name, :type, :cooldown, :rounds

  def initialize(params)
    @id = params["id"]
    @name = params["name"]
    @type = PetType.find(params["petTypeId"])
    @cooldown = params["cooldown"]
    @rounds = params["rounds"]
  end
end
