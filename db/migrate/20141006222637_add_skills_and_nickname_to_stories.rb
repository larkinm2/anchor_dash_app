class AddSkillsAndNicknameToStories < ActiveRecord::Migration
  def change
    add_column :stories, :nickname, :string
    add_column :stories, :skills, :string
  end
end
