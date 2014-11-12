require 'rails_helper'

RSpec.describe "Stories", :type => :request do
  describe "GET /stories" do
    it "route works! Get expected RecordNotFound error" do
      get stories_path
      # binding.pry
      expect(response.status).to be(200)
    end
  end
end

# TODO: Add gem to simulate session data
# I don't think that there's any other way
# to do this.
xdescribe "GET /stories/new for a company", :type => :feature do
  before :each do
    User.create(first_name: "Ryan",
                last_name: "Parks",
                email: "rnparks@gmail.com",
                phone: "(917) 750-2397",
                user_type: "company",
                password: "12345")
  end
    it "loads its new story form" do
    session[:user_id] ||= User.last.id
      visit '/stories/new'
      expect(page).to have_content 'Business name'
  end
end

# TODO: Add gem to simulate session data
# I don't think that there's any other way
# to do this.
xdescribe "GET /stories/new for an individual", :type => :feature do
  before :each do
    User.create(first_name: "Andy",
                last_name: "Fritz",
                email: "frizy@gmail.com",
                phone: "(718) 555-2397",
                user_type: "individual",
                password: "12345")
  end
    it "loads its new story form" do
    session[:user_id] ||= User.last.id
      visit '/stories/new'
      expect(page).to have_content 'Personal website'
  end
end

