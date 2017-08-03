class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.integer :card_id
      t.integer :background_id
      t.integer :rule_id
      t.float :score
      t.boolean :best_score
      t.integer :a
      t.integer :b
      
      t.timestamps
    end
  end
end
