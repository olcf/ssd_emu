# EMU: Software Services Development Group emulation project

## Project Description
Emu is a simulation software designed to show the architecture and operational mechanics of supercomputers used in Oak Ridge National Laboratory. This application helps beginners to familiarize with job submission, queue systems, and schedulers on HPC environment before actually using it in real HPC systems. 
### Key Features:
1. Customizable Machine Creation and Configuration with GPUs and CPUs  
2. SSH configuration to each machines
2. Job Creation and Execution using SLURM
3. Graphical and Command Line Support for Jobs
4. Able to run MPI applications
5. Missions for students to learn the process

## Installation Process
1. Download a local copy of source code from `https://github.com/olcf/ssd_emu` using `git clone git@github.com:olcf/ssd_emu.git` 

### Docker Setup
#### Install and setup docker if you haven't already
- Install docker following the setup from [Docker Docs](https://docs.docker.com/engine/install/fedora/#install-using-the-repository)
- Create a user by `sudo usermod -aG docker $USER`
- `newgrp docker`
- Restart docker to apply changes `systemctl restart docker`

### Easy one-liner setup (for both Production and Development)
- Make `install.sh` executable by running: `chmod u+x install.sh`
- Run `./install.sh` and follow instructions

> Please look into [docs/development.md](./docs/development.md) for additional information

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


##  Credits
@ssd_team
