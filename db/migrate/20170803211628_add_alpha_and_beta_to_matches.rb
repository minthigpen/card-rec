class AddAlphaAndBetaToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :alpha, :integer
    add_column :matches, :beta, :integer
  end
end
