# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
   3.2.2

* Configuration
  1. Configure Cors for your development machine by going to `/config/initializers/cors.rb`. Currently it is setup for `http://localhost:5173` where frontend(vuejs app) runs

  2. Setup Docker for simulating user commands
      - Install Docker using [Docker original Docs](https://docs.docker.com/desktop/setup/install/linux/). This code is originally built in Fedora whose docker setup docs can be found [here](https://docs.docker.com/desktop/setup/install/linux/fedora/) . 
      - Make sure your docker is running when you try to run this application. If you have not enabled docker as startup do so by running ` systemctl enable docker.socket` and `systemctl enable docker.service`. If this method doesn't work, try looking at [Docker Linux post install docs](https://docs.docker.com/engine/install/linux-postinstall/). Sometimes, you might not see the docker code working even though it was enabled for startup. You can always restart service using `service docker restart`.
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
   3. If you have installed `docker-desktop`, you might be using different socket than default socket. You might want to update it with default socket so that you are using same socket either via rails api or docker-desktop.
     - You can use command `docker context ls` to show all the context that are available in your system. If desktop-linux is selected, you can change it by using `docker context use default`. 
    
