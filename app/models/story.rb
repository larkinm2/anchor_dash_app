class Story < ActiveRecord::Base
  belongs_to :user
  has_many :pitches, dependent: :destroy
end
