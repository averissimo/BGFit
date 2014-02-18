FactoryGirl.define do
  
  factory :user do
    sequence(:email) { |n| "droid#{n}@example.com"}
    password "notthedroidyouarelookingfor"
    admin false
    factory :admin do
      admin true
    end
  end
  
  factory :model do
    sequence(:title) { |n| "model title#{n}" }
    description "description for this model"
    is_published false
    factory :published_model do
      is_published true
    end
    owner FactoryGirl.create :user
  end
  
  factory :experiment do
    model
    sequence(:title) { |n| "experiment title#{n}" }
    description "description for this experiment"
  end
  
  factory :measurement do
    experiment
    sequence(:title) { |n| "measurement title#{n}" }
    description "description for this experiment"
    date "#{Time.now.year}/#{Time.now.month}/#{Time.now.day}"
    original_data "0\t1\n0\t2\n0\t3\n0\t4\n0\t5"
  end
  
  factory :membership do
    user { FactoryGirl.create(:user) }
    group { FactoryGirl.create(:group) }
  end
  
  factory :group do
    sequence(:title) { |n| "group title#{n}" }
    users {
      Array(5..10).sample.times.map do
        FactoryGirl.create(:user)
      end
    }
  end
  
  factory :accessible do
    permitable FactoryGirl.create :model
    group
    permission_level GlobalConstants::PERMISSIONS[:write]
    factory :accessible_read do
      permission_level GlobalConstants::PERMISSIONS[:read]
    end
  end
  
end