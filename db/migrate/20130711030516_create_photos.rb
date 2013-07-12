class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :tag
      t.string :desc
      t.string :uuid

      t.timestamps
    end
  end
end
