class CreateResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :responses do |t|
      t.integer :card_id
      t.integer :rule_id
      t.boolean :selected

      t.timestamps
    end
  end
end
