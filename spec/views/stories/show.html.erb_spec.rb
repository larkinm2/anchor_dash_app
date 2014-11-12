require 'rails_helper'

RSpec.describe "stories/show", :type => :view do
  before(:each) do
    @story = assign(:story, Story.create!(
      :url => "Url",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/Description/)
  end
end
