require 'rails_helper'

RSpec.describe "pitches/new", :type => :view do
  before(:each) do
    assign(:pitch, Pitch.new(
      :body => "MyString"
    ))
  end

  xit "renders new pitch form" do
    render

    assert_select "form[action=?][method=?]", pitches_path, "post" do

      assert_select "input#pitch_body[name=?]", "pitch[body]"
    end
  end
end
