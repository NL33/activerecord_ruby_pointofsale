class AddLoginToCashiers < ActiveRecord::Migration
  def change
    add_column :cashiers, :login, :string
  end
end
