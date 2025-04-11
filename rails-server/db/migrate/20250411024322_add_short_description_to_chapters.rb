class AddShortDescriptionToChapters < ActiveRecord::Migration[7.0]
  def change
    add_column :chapters, :short_description, :string, default: "This is short description about this chapter"
  end
end
