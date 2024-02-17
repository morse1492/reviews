# Clear existing data
Review.destroy_all
User.destroy_all
Business.destroy_all

# Create a Business
business = Business.create!(
  business_name: "Designer Pet Portraits",
  contact_info: "contact@designerpetportraits.co",
  email: "business@example.com"
)

# Create a User
user = User.create!(
  email: "user@example.com",
  password: "password",
  password_confirmation: "password",
  business: business
)

# Create Reviews
30.times do |i|
  business.reviews.create!(
    platform: ["Google", "Facebook", "Yelp"].sample,
    rating: rand(1..5),
    content: "Sample review content ##{i}",
    responded: [true, false].sample,
    created_at: rand(1..365).days.ago
  )
end

puts "Seed data created successfully!"
