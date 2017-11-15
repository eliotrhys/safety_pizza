require('pry-byebug')
require_relative('./models/pizza_order')
require_relative('./models/customer')

PizzaOrder.delete_all()
Customer.delete_all()

customer1 = Customer.new({ 'name' => 'Zsolt' })
customer1.save()

order1 = PizzaOrder.new({
  'customer_id' => customer1.id,
  'topping' => 'pepperoni',
  'quantity' => 2
  })

order2 = PizzaOrder.new({
  'customer_id' => customer1.id,
  'topping' => 'chicken',
  'quantity' => 4
  })

order1.save()
order2.save

# customers = Customer.all()

customer_test = order1.customer
pizza_orders_test = customer1.pizza_orders


binding.pry
nil
