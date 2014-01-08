# Rake task to create sample users and microposts

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true) # The first user is an admin user
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    
    # Adding microosts to the sample users.
    # The first six users are selected (limit: 6) and 
    # then 50 microposts were made for each of them. 
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5) # Generate fake sample content
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end