class Relationships < ActiveRecord::Migration[7.0]
  def change
    drop_table :relationships
  end
end
