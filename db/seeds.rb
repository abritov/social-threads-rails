# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'

puts "Creating users..."
users = []
10.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password'
  )
end
puts "Created #{users.count} users."

puts "Creating posts..."
posts = []
users.each do |user|
  rand(1..5).times do
    posts << Post.create!(
      author: user,
      body: Faker::Lorem.paragraph(sentence_count: 5)
    )
  end
end
puts "Created #{posts.count} posts."

puts "Creating comments..."
comments = []
users.each do |user|
  posts.sample(rand(0..5)).each do |post|
    comments << Comment.create!(
      author: user,
      post: post,
      text: Faker::Lorem.sentence(word_count: 10)
    )
  end
end
puts "Created #{comments.count} comments."

puts "Creating likes..."
likes = []
users.each do |user|
  posts.sample(rand(0..10)).each do |post|
    begin
      likes << Like.create!(
        user: user,
        post: post
      )
    rescue ActiveRecord::RecordInvalid => e
      # Skip if already liked (due to uniqueness validation)
      puts "Skipping like: #{e.message}"
    end
  end
end
puts "Created #{likes.count} likes."

puts "Creating follows..."
follows = []
users.each do |follower|
  users.sample(rand(0..5)).each do |followed|
    unless follower == followed
      begin
        follows << Follow.create!(
          follower: follower,
          followed: followed
        )
      rescue ActiveRecord::RecordInvalid => e
        # Skip if already following (due to uniqueness validation)
        puts "Skipping follow: #{e.message}"
      end
    end
  end
end
puts "Created #{follows.count} follows."

puts "Seed data created successfully!"
