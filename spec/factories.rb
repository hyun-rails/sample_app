FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    # Below code allows us to use FactoryGirl.create(:admin)
    # to create an administrative user 
    factory :admin do
    	admin true
    end

  end
end