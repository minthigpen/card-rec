class AddTypeToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :type, :string
  end
end
