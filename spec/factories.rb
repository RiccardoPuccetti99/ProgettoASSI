FactoryBot.define do
    factory :guide do
      title { "My Guide" }
      champ_name { "My Champion" }
      champ_role { "My Role" }
      champ_rune { "My Rune" }
      skill_order { "My Skill Order" }
      path_jungle { "My Path Jungle" }
      item { "My Item" }
      guida { "My Guide Description" }
      counter { "My Counter" }
      ideal { "My Ideal" }
      association :user
    end
  
    FactoryBot.define do
      factory :user do
        sequence(:uid) { |n| "User #{n}" }
        sequence(:email) { |n| "guide#{n}@example.com" }
        password { "ciaociao123" }
      end
    end
  end