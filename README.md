This is a ticket resolution application built with ReactJS using the Next.js framework to capitalize on server side rendering and client side rendering where appropriate. This is particularly beneficial in cases where you want parts of the site pre-rendered and improves Search Engine Optimization.


View the live app here https://ticketing-app-frontend.vercel.app/

## Getting Started

Note, this application serves the frontend written in Next.js which can be found [here]

This assumes you have the frontend in Ruby on rails running. If you do not, this can be found [here](https://github.com/ObieWalker/ticketing-app-frontend.git)



Dependencies and Database:
- MySql
- Ruby (atleast 2.5.0)
- Gem version 3.1.4

To get the server started:

- Git clone the repo running this command

```git clone https://github.com/ObieWalker/ticketing_system.git```

- cd into the root folder

- run the command 

```bash
bundle install
```

- Create a .env file and fill it with the appropriate values based on your database credentials that you have setup in mysql

```
TICKET_APP_DEFAULT_DB_PASSWORD=
TICKET_APP_DEFAULT_DB_USERNAME=
```

-Setup the database with the command

```bash
rails db:setup
```

- Next, migrate the database

```bash
rails db:migrate
```

- run the command 

```bash
rails db:seed
```

This will create an admin, an agent and a customer user. Details of these users can be seen in the '/db/seeds.rb' file which you can use to login as different users on the frontend.


- run the command 

```bash
rails s -p3001 
```

or you can change the `BACKEND_SERVER_URL` on the frontend to whatever you want to match the port you choose here.



### Testing

To run the tests, run this command 

```bash
rspec
```

