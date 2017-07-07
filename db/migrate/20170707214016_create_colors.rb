class CreateColors < ActiveRecord::Migration[5.1]
  def change
    create_table :colors do |t|
      t.integer :image_id
      t.string :rgb
      t.float :red
      t.float :green
      t.float :blue
      t.float :alpha
      t.float :score
      t.float :pixel_fraction

      t.timestamps
    end
  end
end
