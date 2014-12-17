class Product < ActiveRecord::Base
  belongs_to :division
  has_many :purchases
  has_many :customers, through: :purchases
end