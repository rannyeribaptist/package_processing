require "sqlite3"

#
## Open a database
db = SQLite3::Database.new "package_processing.db"

#
## Create the tables
rows = db.execute <<-SQL
  create table products (
    name varchar(30),
    code varchar(30)
  );
SQL

rows = db.execute <<-SQL
  create table packs (
    product_code varchar(30),
    quantity integer,
    value float
  );
SQL

#
## Insert products
db.execute "insert into products values ( ?, ? )", "Croissant", "CF"
db.execute "insert into products values ( ?, ? )", "Blueberry Muffin", "MB11"
db.execute "insert into products values ( ?, ? )", "Vegemite Scroll", "VS5"

#
## Insert packs
db.execute "insert into packs values ( ?, ?, ? )", "VS5", 3, 6.99
db.execute "insert into packs values ( ?, ?, ? )", "VS5", 5, 8.99
db.execute "insert into packs values ( ?, ?, ? )", "MB11", 2, 9.95
db.execute "insert into packs values ( ?, ?, ? )", "MB11", 5, 16.95
db.execute "insert into packs values ( ?, ?, ? )", "MB11", 8, 24.95
db.execute "insert into packs values ( ?, ?, ? )", "CF", 3, 5.95
db.execute "insert into packs values ( ?, ?, ? )", "CF", 5, 9.95
db.execute "insert into packs values ( ?, ?, ? )", "CF", 9, 16.99
