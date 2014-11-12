class AddsAttributesToStoriesTable < ActiveRecord::Migration
  def change
    add_column :stories, :linked_in, :string
    add_column :stories, :personal_site, :string
    add_column :stories, :html, :boolean
    add_column :stories, :css, :boolean
    add_column :stories, :ruby_on_rails, :boolean
    add_column :stories, :ruby, :boolean
    add_column :stories, :python, :boolean
    add_column :stories, :javascript, :boolean
    add_column :stories, :product_management, :boolean
    add_column :stories, :project_management, :boolean
    add_column :stories, :marketing, :boolean
    add_column :stories, :ux_design, :boolean
    add_column :stories, :redis, :boolean
    add_column :stories, :postgresql, :boolean
    add_column :stories, :mysql, :boolean
    add_column :stories, :personal_location, :string
    add_column :stories, :personal_description, :string
    add_column :stories, :image_url, :string
  end
end
