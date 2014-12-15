class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.column :name, :string
      t.column :cashier_id, :integer
      t.timestamps   
    end
  end
end