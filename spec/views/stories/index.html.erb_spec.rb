require 'rails_helper'

RSpec.describe "stories/index", :type => :view do
  before(:each) do
    assign(:stories, [
      Story.create!(
        :url => "Url",
        :description => "Description"
      ),
      Story.create!(
        :url => "Url",
        :description => "Description"
      )
    ])
  end

  xit "renders a list of stories" do
    render
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
