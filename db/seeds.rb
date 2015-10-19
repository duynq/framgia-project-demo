# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name: "Example User", 
            email: "example@railstutorial.org", 
            password: "foobar", 
            password_confirmation: "foobar",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)
            
99.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = Faker::Internet.password
  
  User.create!(name: name, 
            email: email, 
            password: password, 
            password_confirmation: password,
            activated: true,
            activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)

50.times do 
  title = Faker::Lorem.sentence(5)
  content = Faker::Lorem.paragraph
  users.each { |user| user.entries.create!(title: title, content: content) }
end

# Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |u| user.follow(u) }
followers.each { |u| u.follow(user) }

# Add comment to entry
users.each do |user|
  my_entries = user.entries
  user.followers.each do |follower|
    content = Faker::Lorem.sentence(5)
    my_entries.each do |entry|
      follower.comments.create!(content: content, entry_id: entry.id)
    end
  end
end