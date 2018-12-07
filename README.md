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
1. Make sure you can connect to PostgreSQL. At least `CREATE TABLE` priveleges are required.
2. Clone repo
    ```
    $ git clone git@github.com:bfoofoo/bunny-foo-foo-content.git
    ```
3. Copy and edit database config and environment variables
    ```
    $ cp config/database.yml.example config/database.yml
    $ cp .env.example .env
    ```
    *Tip:* to change database name, edit this value in `.env`:
    ```
    DB_NAME='foo'
    ```
4. Install gems
    ```
    $ bundle install --without-production 
    ```
5. Obtain & set up database
    1. Create databases
        ```
        $ rails db:create:all
        ```
    2. Download latest production database dump from server, e.g.
        ```
        $ scp sammy@167.99.156.18:dumps/production_backup/<CURRENT DATE>/production_backup.tar ~/
        ```
        unpack it anywhere you like
        ```
        $ tar xopf production_backup.tar
        ```
    3. Import the to PostgreSQL
        ```
        $ psql -d bffadmin_development -U youruser < /path/to/dump.sql
        ```
    4. Run migrations
        ```
        $ rails db:migrate
        ```
    *Tip*: optionaly, you can skip steps ii. and iii. and start with a blank database, in that case run
     ```
     $ rails db:seed
     ```
     after last step.
 6. To launch app, run:
     ```
     $ rails s
     ```
     You can access api now with base URL `http://localhost:3000`
     
     To launch Sidekiq, run
     ```
     $ sidekiq
     ```
     To access Sidekiq web app, visit `http://localhost:3000/sidekiq`
     
     *Tip:* to run core app and admin panel simultaneously, be sure to launch admin panel on different port e.g.
     ```
     $ rails s -p 3001
     ```
     then access admin panel via `http://localhost:3001`
7. Additionaly, you may wish to install [Admin Panel](https://github.com/bfoofoo/bff-admin-panel) to manage data, see README.md from that repo.
## WARNING
**All models should be synchronized with [Admin Panel](htps://github.com/bfoofoo/bff-admin-panel). All migrations must be created and run at this repo.**
## Deployment
 ```
 $ cap production deploy
 ```
