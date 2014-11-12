class AddsBusinessAttributesToStoriesTable < ActiveRecord::Migration

  def change
    add_column :stories, :business_name, :string
    add_column :stories, :logo_url, :string
    add_column :stories, :business_location, :string
    add_column :stories, :business_description, :string
    add_column :stories, :industry, :string
    add_column :stories, :founders, :string
    add_column :stories, :size, :string
    add_column :stories, :year_founded, :integer
  end

end
