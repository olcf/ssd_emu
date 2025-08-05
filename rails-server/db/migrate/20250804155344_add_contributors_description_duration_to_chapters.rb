class AddContributorsDescriptionDurationToChapters < ActiveRecord::Migration[7.0]
  def change
    add_column :chapters, :contributors, :string
    add_column :chapters, :duration_minutes, :integer
    rename_column :chapters, :short_description, :description
  end
end
