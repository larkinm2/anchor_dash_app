class AddTypeColumnToPitches < ActiveRecord::Migration
  def change
    add_column :pitches, :user_type, :string
  end
end


