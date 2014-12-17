class Cashier < ActiveRecord::Base
  has_many :customers
  has_many(:purchases)  #the term purchases in this program means sales transactions

end