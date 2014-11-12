class Pitch < ActiveRecord::Base
  model_name.instance_variable_set(:@route_key, 'pitch')
  belongs_to :story
  has_one :user, through: :story
  validates :body, presence: true
end
