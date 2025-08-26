
## Manual setup (Support for Development without running inside docker)
> Only follow this step if you know what you are doing! 
1. Build docker components inside our application
    - `cd ssd_emu/slurm-docker-cluster`
    - Use `docker compose build` or follow the tutorials in the readme there. 
    - Run `docker compose up -d` to deploy the containers. 
2. Install ruby with rbenv (Fedora)
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
3. Setup postgresql
    - Install postgres following instruction at [fedora-postgresql docs](https://docs.fedoraproject.org/en-US/quick-docs/postgresql/).
    - Install `postgresql-devel` package by `sudo dnf install postgresql-devel` (bundle installer won't work without this package)
    - Make sure you provide all the privileges to current user.
4. Install ruby dependencies using Bundler
    - `cd ssd_emu/rails-server`
    - `rbenv local 3.2.2`
    - `bundle install`
5. Setup databases
    - Create database using `bin/rails db:create`
    - Load database seed using `bin/rails db:seed`
    - Migrate database `bin/rails db:migrate`
6. Launch server
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
