require 'docker'

DOCKER_MAIN_CONTAINER_NAME = "slurmctld"
DOCKER_URL="unix:///var/run/docker.sock"

Docker.url = DOCKER_URL

# Check if the the image that we are using is available or not; If there is not, we can pull it
begin
  puts "Checking if user have already built clusters or not"
  check_docker_compose = `cd ../slurm-docker-cluster && docker compose ps --status running`
  if check_docker_compose.include?("slurmctld")
    puts "Cluster already built! No need to rebuild the cluster"
  else
    puts "Cluster not ready building containers!!! It may take couple of minutes depending on specs on your computer!!"
    docker_build_compose = `cd ../slurm-docker-cluster && docker compose build && docker compose up -d`
    puts docker_build_compose
    list_of_cluster = `cd ../slurm-docker-cluster && docker compose ps --status running`
    puts list_of_cluster
  end
rescue 
  puts "Error while creating and running clusters!!!"
end

# Get the container if container is running else, report a error as it should be running if everything worked 

begin
  serverContainer = Docker::Container.get(DOCKER_MAIN_CONTAINER_NAME)
  serverContainer.start!
rescue 
  puts "Error while starting clusters!!!!"
end

# TODO: Update the code so that our docker initializer starts the docker in sleep mode and not manually

unless serverContainer.info.dig('State') && serverContainer.info.dig('State')['Running']
  puts "Server not running! Need to start"
  serverContainer.start
else
  puts "Server running! Don't need to start"
end

Rails.application.config.serverContainer = serverContainer

# Docs for understanding how Initializers works on Rails: 
# https://www.writesoftwarewell.com/introduction-to-rails-initializers/