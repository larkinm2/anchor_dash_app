require 'rails_helper'

RSpec.describe "pitches/index", :type => :view do
  before(:each) do
    assign(:pitches, [
      Pitch.create!(
        :body => "Body"
      ),
      Pitch.create!(
        :body => "Body"
      )
    ])
  end

  xit "renders a list of pitches" do
    render
    assert_select "tr>td", :text => "Body".to_s, :count => 2
  end
end
