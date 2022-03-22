# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies
sudo apt-get install mysql-server mysql-client libmysqlclient-dev phpmyadmin imagemagick libmagickwand-dev \
                     git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev \
                     libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn postfix

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub test@192.168.1.8
cap production deploy

