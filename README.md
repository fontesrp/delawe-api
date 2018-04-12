# DELAWE-API
Web API for the delawe project. Please, visit the project's repository [here](https://github.com/fontesrp/delawe).

# Live
This API lives in an EC2 instance. It can be accessed through [this](http://delawe.rfapps.co) address, but, since there is no web front-end client, there won't be a lot to see there.

# Running Locally
To run the API locally, make sure you have intalled `Ruby 2.5.0`, `Rails 5.1.5`, `Bundler 1.16.1` and `PostgreSQL 10.3`.

Once all that is set up, clone the repository and run the following from the project's root:

```bash
$ bundle
$ rails db:create
$ rails db:schema:load
$ rails db:seed
$ rails s
```

Now you should have a local server running the API with four users: one admin, one restaurant and two couriers. Here is their info:

| Type       | Username             | Password    |
| ---------- | -------------------- | ----------- |
| Admin      | admin@delawe.com     | supersecret |
| Restaurant | er@apple.com         | supersecret |
| Courier    | jb@crosby.com        | supersecret |
| Courier    | cl@strangelovers.com | supersecret |

You may need to setup you Google API key to enable the geocoding service. Here is how:

```bash
$ echo "ENV['GOOGLE_MAPS_API_KEY'] = 'YOUR_API_KEY'" > config/initializers/app_keys.rb
```

# Licence
I hope for nothing. I fear nothing. I am free. See the [LICENSE](./LICENSE) file for details.
