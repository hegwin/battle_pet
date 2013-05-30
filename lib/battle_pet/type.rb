class BattlePet::Type
  PET_TYPES = { 0 => 'Humanoid',
                1 => 'Dragonkin',
                2 => 'Flying',
                3 => 'Undead',
                4 => 'Critter',
                5 => 'Magical',
                6 => 'Elemental',
                7 => 'Beast',
                8 => 'Aquatic',
                9 => 'Mechanical' }
  
  def self.find(type_id)
    PET_TYPES[type_id]
  end
end
