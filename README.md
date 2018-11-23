# BunnyFooFoo Core Application
 Features:
 * JSON API (+ Swagger)
 * Background job processing (+ Sidekiq Web App)
 * Database handling
## Requirements:
* Ruby v2.4.1
* PostgreSQL v9.5.14
* Redis 3.0
## Development
1. Clone repo
    ```
    $ git@github.com:bfoofoo/bunny-foo-foo-content.git
    ```
2. Copy and edit database config and environment variables
    ```
    $ cp config/database.yml.example config/database.yml
    $ cp .env.example .env
    ```
3. Install gems
    ```
    $ bundle install --without-production 
    ```
4. Obtain & set up database
    1. Create databases
        ```
        $ rails db:create:all
        ```
    2. Download and unpack database dump from production server, see `~/dumps/production_backup` folder
    3. Import to PostgreSQL
        ```
        $ psql -d bffadmin_development < /path/to/dump.sql
        ```
    4. Run migrations
        ```
        $ rails db:migrate
        ```
## WARNING
**All models should be synchronized with [Admin Panel](htps://github.com/bfoofoo/bff-admin-panel). All migrations must be created and run at this repo.**
## Deployment
 ```
 $ cap production deploy
 ```
