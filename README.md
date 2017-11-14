# README

Political fact checking website. For more information see http://demagog.cz/o-nas (in czech).

### Ruby version

2.4.1

## Configuration

Site configuration is done via .env file (see dotenv project).

```
// .env
DEMAGOG_IMAGE_SERVICE_URL=https://pacific-meadow-53023.herokuapp.com
```

### Services (job queues, cache servers, search engines, etc.)

#### Server for requesting static assets from legacy server

HTTP server that upon request downloads an image from the legacy server and caches it locally.

For more information see https://github.com/vaclavbohac/demagog-image-service

### Migration from legacy DB

```sh
rake db:drop db:create db:migrate migration:run
```

### Deployment instructions

Deploy to production:
```sh
cap production deploy
```

Stop production unicorn:
```sh
cap production rvm:hook unicorn:reload
```

Reload production unicorn:
```sh
cap production rvm:hook unicorn:reload
```

Stop production unicorn:
```sh
cap production rvm:hook unicorn:stop
```

Start production unicorn:
```sh
cap production rvm:hook unicorn:start
```
