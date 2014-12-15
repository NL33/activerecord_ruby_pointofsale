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
  press 'x' to exit."
 
  choice = gets.chomp
  case choice
  when 'a'
	add_product
  when 'b'
  	add_cashier

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

welcome
