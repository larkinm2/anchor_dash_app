require 'rails_helper'

RSpec.describe "pitches/edit", :type => :view do
  before(:each) do
    @pitch = assign(:pitch, Pitch.create!(
      :body => "MyString"
    ))
  end

  xit "renders the edit pitch form" do
    render

    assert_select "form[action=?][method=?]", pitch_path(@pitch), "post" do

      assert_select "input#pitch_body[name=?]", "pitch[body]"
    end
  end
end
