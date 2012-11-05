class AddPhotoUrlToPeople < ActiveRecord::Migration
  def change
    add_column :people, :photo_url, :string
  end
end
