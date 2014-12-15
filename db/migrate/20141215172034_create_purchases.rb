class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
       t.belongs_to :customer
       t.belongs_to :product
       t.column :date, :datetime
      t.timestamps
    end
  end
end
