require 'rails_helper'

# create_table :users do |t|
#   t.string :first_name
#   t.string :last_name
#   t.string :email
#   t.string :phone
#   t.string :password_digest
#   t.string :user_type

# To Run: bundle exec rspec spec/models/user_spec.rb

RSpec.describe User, :type => :model do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_uniqueness_of(:email) }
  # it { should validate_presence_of(:phone) }
  it { should have_secure_password }
end
