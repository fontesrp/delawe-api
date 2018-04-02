Transaction.destroy_all
Order.destroy_all
User.destroy_all

admin = User.create first_name: "Admin", last_name: "Admin", email: "admin@delawe.com", user_type: "admin", password: "123@mudar", address: "14539 Wellington Dr, Surrey, BC", business_name: "Admin", phone: "7078675309"
store = User.create first_name: "Eleanor", last_name: "Rigby", email: "er@apple.com", user_type: "store", password: "123@mudar", address: "142 W Hastings St, Vancouver, BC", business_name: "Grilled Gourmet", phone: "6045592633"
c1 = User.create first_name: "Judy", last_name: "Blue", email: "jb@crosby.com", user_type: "courier", password: "123@mudar", address: "555 W Hastings St, Vancouver, BC", phone: "6046897304"
c2 = User.create first_name: "Cara", last_name: "Lin", email: "cl@strangelovers.com", user_type: "courier", password: "123@mudar", address: "475 W Georgia St, Vancouver, BC", phone: "6046657265"

o = Order.create address: "179 Keefer Pl, Vancouver, BC", value: 10.02, store: store
o.courier = c1
o.assign!
o.pickup!
o.deliver!

o = Order.create address: "240 E Cordova St, Vancouver, BC", value: 15.00, store: store
o.courier = c1
o.assign!
o.pickup!

o = Order.create address: "630 Hamilton St, Vancouver, BC", value: 22, store: store
o.courier = c2
o.assign!

o = Order.create address: "808 Beatty St, Vancouver, BC", value: 3.75, store: store
o.courier = c2
o.assign!
o.cancel!

o = Order.create address: "120 Milross Ave, Vancouver, BC", value: 33, store: store

store.couriers << c1
store.couriers << c2

puts "Created #{User.count} users"
puts "Created #{Order.count} orders"
puts "Created #{Transaction.count} transactions"
