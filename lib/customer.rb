class Customer < ActiveRecord::Base
  belongs_to :cashier
  has_many :purchases
  has_many :products, through: :purchases

end