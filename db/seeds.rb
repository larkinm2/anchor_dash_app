# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.destroy_all
Story.destroy_all
Pitch.destroy_all

def random_user_company
  response = HTTParty.get("http://api.randomuser.me/")
  first_name = response['results'][0]['user']['name']['first']
  last_name = response['results'][0][
    'user']['name']['last']
  email = response['results'][0]['user']['email']
  phone = response['results'][0]['user']['phone']
  user_type = "company"
  password = response['results'][0]['user']['password']
  User.create(first_name: first_name, last_name: last_name, email: email, phone: phone, user_type: user_type, password: password)
end

def random_user_individual
  response = HTTParty.get("http://api.randomuser.me/")
  first_name = response['results'][0]['user']['name']['first']
  last_name = response['results'][0]['user']['name']['last']
  email = response['results'][0]['user']['email']
  phone = response['results'][0]['user']['phone']
  user_type = "individual"
  password = response['results'][0]['user']['password']
  User.create(first_name: first_name, last_name: last_name, email: email, phone: phone, user_type: user_type, password: password)
end

def random_story
    skills                = ["ruby", "php", "c", "marketing", 'rapid hungover recovery', 'sales', 'able to leap talls buildings']
    url                   = Faker::Internet.url
    description           = Faker::Company.catch_phrase
    linked_in             = Faker::Internet.url
    personal_site         = Faker::Internet.url
    html                  = [true, false].sample
    css                   = [true, false].sample
    ruby_on_rails         = [true, false].sample
    ruby                  = [true, false].sample
    python                = [true, false].sample
    javascript            = [true, false].sample
    product_management    = [true, false].sample
    project_management    = [true, false].sample
    marketing             = [true, false].sample
    ux_design             = [true, false].sample
    redis                 = [true, false].sample
    postgresql            = [true, false].sample
    mysql                 = [true, false].sample
    personal_location     = Faker::Address.city
    personal_description  = Faker::Company.bs
    image_url             = Faker::Company.logo
    business_name         = Faker::Company.name
    logo_url              = Faker::Company.logo
    business_location     = Faker::Address.city
    business_description  = Faker::Company.bs
    my_skills             = "#{skills.sample}, #{skills.sample}, #{skills.sample}"
    nickname              = Faker::Name.name
    industry              = ["Web Development", "Finance", "Back-end Development", "Media", "Advertising"].sample
    founders              = "#{Faker::Name.name}, #{Faker::Name.name}, #{Faker::Name.name}"
    size                  = rand(100)
    year_founded          = (1975..2014).to_a.sample
    Story.create( user_id: rand(1..50),
                  url: url,
                  description: description,
                  linked_in: linked_in,
                  personal_site: personal_site,
                  skills: my_skills,
                  nickname: nickname,
                  personal_location: personal_location,
                  personal_description: personal_description,
                  image_url: image_url,
                  business_name: business_name,
                  logo_url: logo_url,
                  business_location: business_location,
                  business_description: business_description,
                  industry: industry,
                  founders: founders,
                  size: size,
                  year_founded: year_founded
                )
end

def random_pitch
  Pitch.create(story_id: "#{rand(1..100).to_s}", body: "#{Faker::Lorem.sentence}")
end


ryan = User.create(first_name: "Ryan", last_name: "Parks", email: "rnparks@gmail.com", phone: "(917) 750-2397", user_type: "company", password: "12345")
pj = User.create(first_name: "PJ", last_name: "Hughes", email: "pj@ga.co", phone: "(855) 288-0881", user_type: "company", password: "thisisfake")
phil = User.create(first_name: "Phil", last_name: "Lamplaugh", email: "philco@ga.co", phone: "(855) 288-0881", user_type: "individual", password: "bullshitpassword")
travis = User.create(first_name: "Travis", last_name: "Vander Hoop", email: "trav@ga.co", phone: "(855) 288-0881", user_type: "individual", password: "notrealatall")

#pj_story = Story.create(user_id: 1, url: "https://generalassemb.ly/", description: "GA is building a Website for people who are in a bad place in their life." )
#phil_story = Story.create(user_id: 2, url: "https://www.linkedin.com/pub/phillip-lamplugh/3/7ab/986", description: "I am a Brooding Visionaire." )
#travis_story = Story.create(user_id:3, url: "https://twitter.com/YourFriendTrav", description: "Instructor at GA." )

# # Commented out until Pitch model and controller is created.
#pj_pitch = Pitch.create(body: "I'm looking for a Ruby on Rails Wizard")
#phil_pitch = Pitch.create(body: "I am a Ruby on Rails Wizard.")
#travis_pitch = Pitch.create(body: "I like the Bachelorette.")

#pj_pitch.story = pj_story
#phil_pitch.story = phil_story
#travis_pitch.story = travis_story

#pj_pitch.save
#phil_pitch.save
#travis_pitch.save

#generating random users
25.times do
  random_user_company
  random_user_individual
end

100.times do
  random_story
end


500.times do
  random_pitch
end

# html: html,
#                   css: css,
#                   ruby_on_rails: ruby_on_rails,
#                   ruby: ruby,
#                   python: python,
#                   javascript: javascript,
#                   product_management: product_management,
#                   project_management: project_management,
#                   marketing: marketing,
#                   ux_design: ux_design,
#                   redis: redis,
#                   postgresql: postgresql,
#                   mysql: mysql,
