class CreateCashiers < ActiveRecord::Migration
  def change
    create_table :cashiers do |t|
      t.column :name, :string #note: the name and login field were added through separate migrations because they were not being read here.
      t.column :login, :string
      t.timestamps   
    end
  end
end