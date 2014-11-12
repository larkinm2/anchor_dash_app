require 'rails_helper'

RSpec.describe "pitches/show", :type => :view do
  before(:each) do
    @pitch = assign(:pitch, Pitch.create!(
      :body => "Body"
    ))
  end

  xit "renders attributes in <p>" do
    render
    expect(rendered).to match(/Body/)
  end
end
