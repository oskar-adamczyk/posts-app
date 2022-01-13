# UMAI Coding Assessment 

## Test for Ruby on Rails Developer at UMAI
It is required to create a JSON API service in Ruby without using Ruby on Rails.

### How to run:
#### locally
>_if not having postgres locally_
> 
> docker-compose up -d db

```
cd backend
cp ./.env.example ./.env
ruby main.rb
```

Application should be reachable on http://localhost:3000.

#### via docker
```
cp ./backend/.env.example ./backend/./.env
docker-compose up
```

Application should be reachable on http://localhost:3000 or (thanks to traefik) on http://gateway.posts-app.localhost.

### Used tools:
- docker + docker-compose
- traefik
- postgres 13
- [JSON API](https://jsonapi.org/) standard for requests and responses normalizations
- [JSON Schema](https://json-schema.org/) for request and response (only on dev and test stage) validation
- ruby 3.0.3 with the most common gemset
>some of gems are actually used by Rails framework as well, list is placed in [Gemfile](./backend/Gemfile)

### Made assumptions:
- Entities: replaced login with email for user, just it is quite common to have login as email +
we can test and present some validation of json schema, active model inside unit tests layer.
- Worker: for current need rufus scheduler should be enough,
on next iteration it could be replaced with actual active job impelementation with usage of goodjob,
another option could be sidekiq or something like that.
- API - creating resources. I am aware that on assessment it is stated to use 200 status for successful 
create action but I assumed it is more proper to use 201 (created) which is kinda dedicated for such actions
- API - submitting feedback - I am not sure if it is good idea to return list of resources after create action.
From my perspective, we should return created resource with link pointing to endpoint with
listing feedbacks filtered by owner. Currently, pagination is not introduced, from my perspective it should be introduced
but in mentioned, index endpoint linked in response.

### Potential improvements:
#### what I could do better if I had more time
- Higher unit test coverage for json schema validator and service objects.
- More flexible router, current IMHO is _good enough_.
- Better app initializer separation - dedicated places for configs and setup of application.
- Introducing API DOC (e.g. swagger) for service - actually would be possible if we
would use Rails framework - in my private project I used json schemas, integration tests, rswag and rspec to
automatically generate swagger jsons and render swagger UI but gems required for that are baked into Rails framework
unfortunately.
- Continues Delivery/Deployment with heroku/digital ocean or something cheap like linode.
- Uploading generated report to s3 or any other file bucket.
- Infrastructure as a code via terraform for said deployment infra or file buckets.
- Store rubocop, rubycritic and rspec reports in gh actions artifact to preview it in more convenient way.