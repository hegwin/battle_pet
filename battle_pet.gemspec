Gem::Specification.new do |s|
  s.name        = 'battle_pet'
  s.version     = '0.2.3'
  s.date        = '2013-06-04'
  s.summary     = "WoW BattlePet"
  s.description = "A simple gem to get data from WoW BattlePet API"
  s.authors     = ["Hegwin Wang"]
  s.email       = 'zwt315@163.com'
  s.files       = [ "lib/battle_pet.rb",
                    "lib/battle_pet/ability.rb",
                    "lib/battle_pet/type.rb",
                    "lib/battle_pet/translator.rb",
                    "test/data/mechanical_squirrel_cn.json",
                    "test/data/mechanical_squirrel_us.json",
                    "test/test_battle_pet.rb",
                    "README.md",
                    "Rakefile" ]
  s.homepage    = 'https://github.com/hegwin/battle_pet'
end
