require('pg')
require_relative('../db/sql_runner')
require_relative('customer')

class PizzaOrder

  attr_accessor :customer_id, :quantity, :topping
  attr_reader :id

  def initialize(options)
    @customer_id =  options['customer_id']
    @quantity = options['quantity'].to_i
    @topping = options['topping']
    @id = options['id'].to_i if options['id']
  end

  def save
    # create a connection to the db
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    # save some SQL into a variable
    sql = "INSERT INTO pizza_orders(
        quantity,
        topping,
        customer_id
      )
      VALUES (
        $1, $2, $3
      )
      RETURNING *"
    values = [@quantity, @topping, @customer_id]
    db.prepare("save", sql)
    # execute the SQL
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    # close database connection
    db.close
  end

  def self.all
    db = PG.connect({dbname: 'pizza_orders', host: 'localhost'})
    sql = "SELECT * FROM pizza_orders"
    db.prepare("all", sql)
    orders = db.exec_prepared("all")
    db.close
    return orders.map { |order_hash| PizzaOrder.new( order_hash ) }
  end

  def self.delete_all()
   	db = PG.connect( { dbname: 'pizza_orders', host: 'localhost' } )
    sql = "DELETE FROM pizza_orders"
    values = []
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all", values)
    db.close
  end

  def delete()
    db = PG.connect( { dbname: 'pizza_orders', host: 'localhost' } )
    sql = "DELETE FROM pizza_orders
    WHERE id = $1"
    values = [@id]
    db.prepare("delete_one", sql)
    db.exec_prepared("delete_one", values)
    db.close
  end

  def update()
    db = PG.connect( { dbname: 'pizza_orders', host: 'localhost' } )
    sql = "UPDATE pizza_orders
    SET
    (
    	first_name,
    	last_name,
    	topping,
    	quantity
    ) =
    (
    	$1, $2, $3, $4
    )
    WHERE id = $5"
    values = [@first_name, @last_name, @topping, @quantity, @id]
    result = SqlRunner.run(sql, values)
  end

  def customer
    sql = 'SELECT * FROM customers
    WHERE id = $1'
    values = [@customer_id]
    customer = SqlRunner.run(sql, values)
    return customer.map{ |customer| Customer.new(customer) }
    # return Customer.new(customer[0])
  end

end
