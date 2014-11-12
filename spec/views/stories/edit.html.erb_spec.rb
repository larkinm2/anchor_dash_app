require 'rails_helper'

RSpec.describe "stories/edit", :type => :view do
  before(:each) do
    @story = assign(:story, Story.create!(
      :url => "MyString",
      :description => "MyString"
    ))
  end

  xit "renders the edit story form" do
    render

    assert_select "form[action=?][method=?]", story_path(@story), "post" do

      assert_select "input#story_url[name=?]", "story[url]"

      assert_select "input#story_description[name=?]", "story[description]"
    end
  end
end
