# Become an hero with finances
## Take over life with ease

## Installation instructions

```bundle install && bundle exec rake db:setup```

## Running:

```bundle exec rails s```

Also you need to run task daemon on front

```bundle exec crono RAILS_ENV=development```

Or as daemon

```bundle exec crono start RAILS_ENV=development```

# Testing

```bundle exec rspec```

## Do not forget to stop the daemon if you have run it before

```bundle exec crono stop RAILS_ENV=development```
