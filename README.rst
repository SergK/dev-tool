Description
===========

This tool provides number of microservices implemented in docker environment:

* nginx
* php-fpm
* memcached
* mariadb (mysql)
* sphinx
* redis

All the above microservices are based on debian:jessie

How-to use
==========

* All the services are managed by docker-compose
* All persistent data is stored on your host in /srv directory:

  - /srv/logs  - nginx logs
  - /srv/mysql - database
  - /srv/www   - www-data

System Requirements
-------------------

* Docker >= 1.12
* Ansible 2.1

Initial configuration
---------------------

.. code-block:: bash

    # Install required packages
    sudo apt-get install libffi-dev libssl-dev libyaml-dev python-pip python-dev python-virtualenv

    # Clone code
    git clone https://github.com/SergK/dev-tool

    # Create venv, for example in ~/venv/dev-tool:
    cd dev-tool
    virtualenv ~/venv/dev-tool
    source ~/venv/dev-tool/bin/activate
    pip install --upgrade -r requirements.txt

    # Create a new Docker network. Make sure it doesn't overlap with already existing ones.
    docker network create -d bridge --subnet 172.10.10.0/24 dev-net

Working with code
-----------------

All services are available on *localhost*. To address services inside containers,
you need to use their names. Please check the list below:

format is: *service-name-inside-container: PORT*

* db: 3306
* memcached: 11211
* nginx: 80
* php: 9000
* redis: 6379
* sphinx: 9312 and 9306

for example, if you need to address from your php application database, you need to
point database hostname: *db*, for example:

::

    username: mysqluser
    password: somesecretpassword
    databse: mybestdatabse
    hostname: db

the same is true for the rest services. But again, if you need to access to database from
your host, you need to point *localhost:3306*

All your code should be placed in */srv/www* directory if it doesn't exist, please do this

Working with services
---------------------

To *start* the services you need activate virtualenv:

    source ~/venv/dev-tool/bin/activate

Start the services:

    cd dev-tool/docker-compose

    ./start_all.sh

To stop the services, do the same as above, but:

    ./remove_all.sh
