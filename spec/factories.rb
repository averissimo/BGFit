FactoryGirl.define do
  
  factory :user do
    sequence(:email) { |n| "droid#{n}@example.com"}
    password "notthedroidyouarelookingfor"
    
    factory :admin do
      admin true
    end
  end
end