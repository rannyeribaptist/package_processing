require "sqlite3"
require 'json'

# Open a database
db = SQLite3::Database.open "package_processing.db"

# p db.execute( "select * from products" )
code = 'mb11'
quantity = 9
packs = db.execute( "select quantity, value from packs where product_code = ? order by quantity", code.upcase )
packs = JSON.parse(packs.map{|pack| {quantity: pack[0], value: pack[1]} }.to_json, object_class: OpenStruct)
p packs
