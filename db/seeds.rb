# Clear existing data
Review.destroy_all
User.destroy_all
Business.destroy_all
Emailtemplate.destroy_all
Campaign.destroy_all

# Create a Business
business = Business.create!(
  business_name: "Designer Pet Portraits",
  contact_info: "contact@designerpetportraits.co",
  email: "business@example.com"
)

emailtemplates = [
  {
    content: "It is great to hear that! Please leave us your feedback.",
    subjectline: "Thank you!",
    template_name: "Thank_you"
  },
  {
    content: "Please leave your experience about it.",
    subjectline: "Sorry to hear that!",
    template_name: "Feedback"
  },
  {
    content: "",
    subjectline: "",
    template_name: "New"
  }
]

emailtemplates.each do |template|
  Emailtemplate.create!(
    content: template[:content],
    subjectline: template[:subjectline],
    business_id: business.id,
    template_name: template[:template_name]
  )
end

campaign = Campaign.create!(
  name: "Test- campaign",
  business_id: business.id,
  emailtemplate_id: Emailtemplate.order("RANDOM()").limit(1).first.id,
  recipient_list: "John"
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
