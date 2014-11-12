module TestHelpers

  def create_user
    User.create(first_name: "Ryan",
                last_name: "Parks",
                email: "rnparks@gmail.com",
                phone: "(917) 750-2397",
                user_type: "company",
                password: "12345")
  end

  def login
    visit '/login'
    within("div.login") do
      fill_in 'Email', :with => 'rnparks@gmail.com'
      fill_in 'Password', :with => '12345'
      click_button 'Login'
    end
  end
end

