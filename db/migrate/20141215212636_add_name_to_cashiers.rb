class AddNameToCashiers < ActiveRecord::Migration
  def change
    add_column :cashiers, :name, :string
  end
end
