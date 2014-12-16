class AddTotalToProducts < ActiveRecord::Migration
  def change
    add_column :products, :total, :float
  end
end
