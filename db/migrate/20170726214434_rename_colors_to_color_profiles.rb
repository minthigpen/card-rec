class RenameColorsToColorProfiles < ActiveRecord::Migration[5.1]
  def change
    rename_table :colors, :color_profiles
  end
end
