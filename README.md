# EMU: Software Services Development Group emulation project

## Project Description
Emu is a simulation software designed to show the architecture and operational mechanics of supercomputers used in Oak Ridge National Laboratory. This application helps beginners to familiarize with job submission, queue systems, and schedulers on HPC environment before actually using it in real HPC systems. 
### Key Features:
1. **Customizable Machine Creation and Configuration**  
   - Users can create virtual HPC machines by specifying parameters like nodes, CPUs, cores, and GCDs per node.  
   - Helps beginners understand HPC and supercomputer architecture concepts.

2. **Job Creation and Execution**  
   - Web Interface in each machine helps users to design and submit small HPC jobs, and understand `slurm` scripts.  
   - Dynamically updates `slurm` scripts as users input each values in the GUI.

3. **Command Line Support**  
   - The CLI environment supports limited commands for users who haven’t logged in.  
   - After logging in via SSH, users gain full CLI support created using websockets, replicating a real HPC environment.

4. **Feedback**  
   - Errors during job submission will provide detailed feedback, helping users understand and correct mistakes.


## How to install and setup Frontend and Backend
1. Download local copy of source code from `https://github.com/olcf/ssd_emu` using `git clone git@github.com:olcf/ssd_emu.git` 

### Docker Setup
1. Install and setup docker if you haven't already
    - Install docker following the setup from [Docker Docs](https://docs.docker.com/engine/install/fedora/#install-using-the-repository)
    - Create a user by `sudo usermod -aG docker $USER`
    - `newgrp docker`
    - Restart docker to apply changes `systemctl restart docker`
2. Build docker components inside our application
    - `cd ssd_emu/slurm-docker-cluster`
    - Use `docker compose build` or follow the tutorials in the readme there. 
    - Run `docker compose up -d` to deploy the containers. 
### Backend
1. Install ruby with rbenv (Fedora)
    - Install rbenv dependency from [Fedora rbenv](https://developer.fedoraproject.org/start/sw/web-app/rails.html)
    - When installing rbenv from fedora official repository, it won't have `3.2.2` which is why we need to re install `rbenv` manually.
    - Clone [ruby-build](https://github.com/rbenv/ruby-build) by `git clone https://github.com/rbenv/ruby-build.git`
    - Run following command to install `ruby-build`
    - ```
        cd ruby-build
        chmod u+x ./install.sh
        ./install.sh
        rbenv install 3.2.2
      ```
    - Check the version by running `rbenv --version`
2. Setup postgresql
    - Install postgres following instruction at [fedora-postgresql docs](https://docs.fedoraproject.org/en-US/quick-docs/postgresql/).
    - Install `postgresql-devel` package by `sudo dnf install postgresql-devel` (bundle installer won't work without this package)
    - Make sure you provide all the privileges to current user.
3. Install ruby dependencies using Bundler
    - `cd ssd_emu/rails-server`
    - `rbenv local 3.2.2`
    - `bundle install`
4. Setup databases
    - Create database using `bin/rails db:create`
    - Load database seed using `bin/rails db:seed`
    - Migrate database `bin/rails db:migrate`
5. Launch server
    - `bin/rails server`

### Frontend
1. Install Node.js and node modules required for this project.
    - Install node js using `sudo dnf install nodejs` for Fedora (Our project uses node with version of `v22.11.0`)
    - Confirm Node.js installation by `node --version` which outputs something like `v22.11.0`.
2. Install node modules
    - `cd ssd_emu/vue-client`
    - Install node modules by running `npm i`.
3. Run the project
    - `npm run dev`
    - Check [localhost:5173](http://localhost:5173) to make sure it is running. 

##  How to use 
### Creating new machine
1. Create a new machine by clicking on `Create new machine` available in Left Navigation Pane under `List all machines` 

##  Credits
@ssd_team

## TODOs
 - [x] Integrate docker component with slurm built inside.
 - [x] Use websocket to simulate ssh environment.
 - [x] Preserve directory on each command in CLI on frontend and backend
 - [x] Implement job submission via `slurm cluster sbatch` instead of regular `bash` scripts
 - [x] Add architecture image on each machine page using mermaidJS(Basic version only)
 - [ ] Update missions page with documentation and challenge.
   - [x] Implement certain chapters/mission for Demo
   - [ ] Finalize all chapters along with quizzes
 - [ ] Finalize the Command line that we will be using
   - [ ] Explore options and show it to SSD group
