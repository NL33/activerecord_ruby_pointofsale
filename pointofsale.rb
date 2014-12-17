require 'active_record'
require './lib/cashier'
require './lib/customer'
require './lib/product'
require './lib/purchase'


database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Point of Sale (POS) System.\n\n"
  menu
end

def menu
  choice = nil
  until choice == 'x'
  puts "Welcome!\n 
  Press 'a' to enter a new product to the POS; 
  press 'b' to enter a cashier and create a login for him/her;
  press 'c' if you are a cashier, to enter customer products and totals, and show a receipt;
  press 'd' if you are a store manager, to see total sales a cashier has processed;
  press 'x' to exit."
 
  choice = gets.chomp
  case choice
  when 'a'
	add_product
  when 'b'
  add_cashier
  when 'c'
  add_purchases
  when 'd'
   search_by_cashier
  when 'x'
   puts "Good-bye!"
   exit

  else
    puts "Sorry, that wasn't a valid option."
  end
 end
end 

def add_product
  loop do
	puts 'Please enter the name of the product you wish to enter'
	 product_name = gets.chomp
    puts 'Please enter the price of the product'
	 price_entry = gets.chomp
	puts 'Please enter the amount of the product you have in stock'
	 amount_entry = gets.chomp
	product = Product.new({:name => product_name, :price => price_entry, :number => amount_entry })
	product.save 
	puts "#{product_name} has been saved as a product.  Would you like to record another product now? (y/n)"
  break if gets.chomp == 'n'
  end
  menu
end

def add_cashier
  loop do
	puts 'Please enter the name of the cashier you wish to enter'
	 cashier_name = gets.chomp
    puts 'Please enter a login for the cashier'
	 login_entry = gets.chomp
	cashier = Cashier.new({:name => cashier_name, :login => login_entry})
	cashier.save 
	puts "'#{cashier.name}' has been entered, with login: '#{cashier.login}'.  Would you like to enter another cashier? (y/n)"
  break if gets.chomp == 'n'
  end
  menu
end

def add_purchases
  puts "Please enter your name"
    name_entry = gets.chomp
  puts "Please enter your login"
   login_entry = gets.chomp
  if !Cashier.where(:name => name_entry, :login => login_entry).exists?
    puts "Sorry, your name/login information did not match our records, please try again."
    add_purchases
  else
    cashier = Cashier.where(:name => name_entry, :login => login_entry).first
    puts "Welcome #{cashier.name}.\n"
    puts "Please enter your customer's name"
    customer_name = gets.chomp
    customer = Customer.new({:name => customer_name,:cashier_id => cashier.id})
    customer.save
    puts "Please enter the date and time ('YYYY-MM-DD HH:MM:SS')"
    date = gets.chomp
    totals_array = []
    product_summaries = []
    loop do
      puts "Press return to enter a product or press 'c' to complete checkout and show a receipt"
      break if gets.chomp == 'c'
      puts "Please enter the purchased item name"
       product_name = gets.chomp
      puts "enter the price"
       price = gets.chomp
      puts "enter the quantity"
       quantity = gets.chomp
      total = price.to_f * quantity.to_f * 100 / 100
      product = Product.new({:name => product_name, :price => price, :number => quantity, :total => total})
       product.save
      purchase = Purchase.new({:customer_id => customer.id, :product_id => product.id, :date => date, :cashier_id => cashier.id})
       purchase.save
      totals_array << product.total
      product_summaries << "Item: #{product.name}, Price: $#{product.price}, Quantity: #{product.number}, Total: $#{product.total}"
    end
      grand_total =  totals_array.sum * 100 / 100 #math to show not more than 2 decimal spots
      puts "Here is the receipt:"
      puts "Name: #{customer_name}\n"
      puts "Date: #{date}\n"
      product_summaries.each {|summary| puts "#{summary}\n"}
      puts "Grand Total: $#{grand_total}\n\n"
      menu
   end     
end

def search_by_cashier
  puts "Hi There, Store Manager. \n"
  puts "To view the (i) total number of sales and (ii) the total amount a cashier has processed, enter the name of the cashier"
  cashier_name = gets.chomp
  cashier = Cashier.where(:name => cashier_name).first
  puts "#{cashier_name}'s activity has been as follows:\n\n"
  puts "Total Number of this Cashier's Transactions: #{Purchase.where(cashier_id: cashier.id).count}\n"
  total_sum = 0
  cashier.purchases.each {|purchase| total_sum += purchase.product.total}
  puts "Total Value of all this Cashier's Transactions: $#{total_sum}\n\n"
  puts "Press 'a' to search again, or 'b' to return to the main menu"
      if gets.chomp == 'a'
        search_by_cashier
      elsif gets.chomp == 'b'
         menu
      end
end

welcome
