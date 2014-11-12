class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      # TODO: Make user a user object.
      t.string :url
      t.string :description

      t.timestamps
    end
  end
end
