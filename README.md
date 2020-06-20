# Dockerize Laravel
Docker compose to setup nginx, php and mysql for laravel 7.16.1.  

## Directory Structure
```sh
website
├── docker
│   ├── mysql
│   │   └── based.sql
│   ├── nginx
│   │   └── nginx.conf
│   └── php
│       └── Dockerfile
├── docker-compose.yml
├── init-storage
│   └── uploads
└── reset-db.sh
```
## Images
1. nginx → nginx:latest
2. php → php:7.4-fpm
3. mysql → mysql:5.7

## Setup Initial DB
You can choose between using seeder or if you want to use your own sql file for initial database.  
### Using Seeder
1. Open file *docker/php/Dockerfile* and uncomment line 30-32
    ```yaml
    Before:
    30 # RUN php artisan migrate:reset
    31 # RUN php artisan migrate
    32 # RUN php artisan db:seed

    After:
    30 RUN php artisan migrate:reset
    31 RUN php artisan migrate
    32 RUN php artisan db:seed
    ```
2. Open file *docker-compose.yml* and comment line 11
    ```yaml
    Before:
    11 - ./docker/mysql/based.sql:/docker-entrypoint-initdb.d/based.sql

    After:
    11 # - ./docker/mysql/based.sql:/docker-entrypoint-initdb.d/based.sql
    ```

## Setup Initial storage
In this deployment we use command *php artisan storage:link* to connect public directory with storage directory.  
```yaml
Since:
    public/storage → storage/app/public
Therefore:
    public/storage/uploads ≍ storage/app/public/uploads
```
To setup initial files for storage directory just paste your file into *init-storage/uploads* and Dockerfile will copy those file when creating php image.

## Deployment using Docker
1. Deploy nginx, php-fpm, and mysql using docker-compose
    ```bash
    docker-compose up -d
    ```
2. Stop all container
    ```bash
    docker stop leru_nginx leru_mysql leru_php_fpm
    ```
3. Remove all container
    ```bash
    docker rm leru_nginx leru_mysql leru_php_fpm
    ```
4. Remove php-fpm image
    ```bash
    docker rmi website_php_fpm
    ```
5. Reset mysql data
    ```bash
    bash reset-db.sh
    ```
