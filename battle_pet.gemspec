Gem::Specification.new do |s|
  s.name        = 'battle_pet'
  s.version     = '0.1.4'
  s.date        = '2013-05-29'
  s.summary     = "WoW BattlePet"
  s.description = "A simple gem to get data from WoW BattlePet API"
  s.authors     = ["Hegwin Wang"]
  s.email       = 'zwt315@163.com'
  s.files       = [ "lib/battle_pet.rb",
                    "lib/battle_pet.yml",
                    "lib/pet_ability.rb",
                    "lib/pet_type.rb",
                    "test/data/mechanical_squirrel_cn.json",
                    "test/data/mechanical_squirrel_us.json",
                    "test/test_battle_pet.rb",
                    "README.md",
                    "Rakefile" ]
  s.homepage    = 'https://github.com/hegwin/battle_pet'
end
