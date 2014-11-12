require 'rails_helper'

# create_table :stories do |t|
#   # TODO: Make user a user object.
#   t.string :user
#   t.string :url
#   t.string :description

RSpec.describe Story, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
  it { should belong_to(:user) }
  xit { should validate_presence_of(:user) }
  # it { should validate_presence_of(:url) }
  xit { should validate_presence_of(:description) }
end
