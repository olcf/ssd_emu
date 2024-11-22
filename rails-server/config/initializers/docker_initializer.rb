require 'docker'

DOCKER_MAIN_CONTAINER_NAME = "simulation_container"
DOCKER_IMAGE_NAME="opensuse/leap"


# Check if the the image that we are using is available or not; If there is not, we can pull it
begin
  Docker::Image.get(DOCKER_IMAGE_NAME)
  puts "Image already exist! No need to pull"

rescue Docker::Error::NotFoundError
  puts "Pulling #{DOCKER_IMAGE_NAME} image! "
  Docker::Image.create('fromImage':DOCKER_IMAGE_NAME)
end

# Get the container if container is running else, create a new container and then run
# Currently, we are only using one docker so, we will only have one docker container. In future, we might add multiple containers acting as node

begin
  serverContainer = Docker::Container.get(DOCKER_MAIN_CONTAINER_NAME)
  serverContainer.start!
  puts "using existing container: #{DOCKER_MAIN_CONTAINER_NAME}"
rescue Docker::Error::NotFoundError
  puts "Creating new container as old container doesn't exist!"
  # REVIEW: See if we need to run the container always, or with failure, or 'unless-stopped'
  serverContainer =Docker::Container.create(
    'name': DOCKER_MAIN_CONTAINER_NAME,
    'Image': DOCKER_IMAGE_NAME,
    'Cmd':['tail','-f','/dev/null']
  )
  serverContainer.start!
end

# TODO: Update the code so that our docker initializer starts the docker in sleep mode and not manually
# For now, we have to manually start docker in sleep mode or in interactive shell so that it doesn't close on its own. 
unless serverContainer.info.dig('State') && serverContainer.info.dig('State')['Running']
  puts "Server not running! Need to start"
  serverContainer.start
else
  puts "Server running! Don't need to start"
end

Rails.application.config.serverContainer = serverContainer

# Docs for understanding how Initializers works on Rails: 
# https://www.writesoftwarewell.com/introduction-to-rails-initializers/