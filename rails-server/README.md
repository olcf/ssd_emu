# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration
1. Configure Cors for your development machine by going to `/config/initializers/cors.rb`. Currently it is setup for `http://localhost:5173` where frontend(vuejs app) runs

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
2. Setup Docker for simulating user commands
   - Install Docker using [Docker original Docs](https://docs.docker.com/desktop/setup/install/linux/). This code is originally built in Fedora whose setup docs can be found [here](https://docs.docker.com/desktop/setup/install/linux/fedora/) . 
   - Make sure your docker is running when you try to run this application. If you have not enabled docker as startup do so by running ` systemctl enable docker.socket` and `systemctl enable docker.service`. If this method doesn't work, try looking at [Docker Linux post install docs](https://docs.docker.com/engine/install/linux-postinstall/). 
   - Confirm if docker is correctly setup by going to console move using command below 
   ```
    rails c
    require 'docker'
    Docker.version 
   ```
   NOTE: We are using unix socket to connect with Docker API(`unix:///var/run/docker.sock`).

   Above command should output something like this...
   ```
   {"Platform"=>{"Name"=>"Docker Engine - Community"}, "Components"=>
     [{"Name"=>"Engine",
    "Version"=>"27.3.1",
    "Details"=>
     {"ApiVersion"=>"1.47",
      "Arch"=>"amd64",
      "BuildTime"=>"2024-09-20T11:41:01.000000000+00:00",
      "Experimental"=>"false",
   ```
    
