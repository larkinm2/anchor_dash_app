require 'rails_helper'

RSpec.describe "Pitches", :type => :request do
  describe "GET /pitches" do
    it "route works!" do
      get pitches_path
      expect(response.status).to be(200)
    end
  end
end
