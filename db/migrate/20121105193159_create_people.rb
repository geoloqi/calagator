class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :nickname
      t.string :twitter
      t.string :website
      t.string :email
      t.string :geoloqi_token

      t.timestamps
    end
  end
end
