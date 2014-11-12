class CreatePitches < ActiveRecord::Migration
  def change
    create_table :pitches do |t|
      t.string :body, limit: 140
      t.references :story, index: true
      t.timestamps
    end
  end
end
