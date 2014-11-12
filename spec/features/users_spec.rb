require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "GET /users" do
    it "lists all current users." do
      get users_path
      # binding.pry
      expect(response.status).to be(200)
    end
  end
end


describe "GET /users", :type => :feature do
  before :each do
    User.create(first_name: "Ryan",
                last_name: "Parks",
                email: "rnparks@gmail.com",
                phone: "(917) 750-2397",
                user_type: "company",
                password: "12345")
  end
  # TODO: Factor this out into a helper class
  it "lists the user (Ryan Parks) recently added" do
    visit '/users'
    expect(page).to have_content 'Ryan Parks'
  end
end
