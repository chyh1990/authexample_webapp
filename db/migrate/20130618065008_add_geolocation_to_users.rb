class AddGeolocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :decimal, :precision => 8, :scale => 5
    add_column :users, :longitude, :decimal, :precision => 8, :scale => 5
    add_column :users, :geotimestamp, :datetime
  end
end
