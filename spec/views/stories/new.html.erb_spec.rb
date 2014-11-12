require 'rails_helper'

RSpec.describe "stories/new", :type => :view do
  before(:each) do
    assign(:story, Story.new(
      :url => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new story form" do
    render

    assert_select "form[action=?][method=?]", stories_path, "post" do

      assert_select "input#story_url[name=?]", "story[url]"

      assert_select "input#story_description[name=?]", "story[description]"
    end
  end
end
