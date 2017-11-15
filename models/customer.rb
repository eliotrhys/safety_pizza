require('pg')
require_relative('../db/sql_runner')
require_relative('pizza_order')

class Customer

  attr_reader :name, :id

  def initialize(options)
    @name = options['name']
    @id = options['id'] if options['id']
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql, values = [])
    return customers.map { |customer_hash| Customer.new(customer_hash) }
  end

  def save
    db = PG.connect( {dbname: 'pizza_orders', host: 'localhost' } )
    sql = 'INSERT INTO customers
    (
    name
    )
    VALUES(
    $1
    )
    RETURNING *'
    values = [@name]
    db.prepare('save', sql)
    saved_customer = db.exec_prepared('save', values)
    @id = saved_customer[0]['id'].to_i
    db.close
  end

  def self.delete_all
    db = PG.connect( {dbname: 'pizza_orders', host: 'localhost'} )
    sql = 'DELETE FROM customers'
    values = []
    db.prepare('delete_all', sql)
    db.exec_prepared('delete_all', values)
    db.close
  end

  def pizza_orders()
    sql = 'SELECT * FROM pizza_orders
    WHERE customer_id = $1'
    values = [@id]
    orders = SqlRunner.run(sql, values)
    return orders.map{ |pizza_order| PizzaOrder.new(pizza_order) }
  end

end
