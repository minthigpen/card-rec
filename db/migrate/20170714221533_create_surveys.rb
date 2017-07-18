class CreateSurveys < ActiveRecord::Migration[5.1]
  def change
    create_table :surveys do |t|
      t.integer :card_id

      t.timestamps
    end
  end
end
