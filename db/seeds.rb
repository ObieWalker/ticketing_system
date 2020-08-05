
#create an admin, agent and customer
users = User.create([
  { email: 'admin@gmail.com', username: 'admin', role: 0 },
  { email: 'agent@gmail.com', username: 'agent', role: 1 },
  { email: 'customer@gmail.com', username: 'customer', role: 2 },
])

UserAuthentication.create([
  { user_id: users.first.id, email: users.first.email, password: 'password' },
  { user_id: users.second.id, email: users.second.email, password: 'password' },
  { user_id: users.third.id, email: users.third.email, password: 'password' },
])