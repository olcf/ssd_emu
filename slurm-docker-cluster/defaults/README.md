# How to edit files/folder under this directory

## Modulefiles:
- Understand the process of writing module files [here](https://lmod.readthedocs.io/en/latest/015_writing_modules.html). 
- Functions provided by lmod [here](https://lmod.readthedocs.io/en/latest/050_lua_modulefiles.html#). Especially look into functions like`prepend_path`, `pathJoin`, `setenv`.
- Check modulefiles/mpich/4.3.1.lua before writing any modules
- Make sure we are installing module in Dockerfile before add module file
- Check if it works inside docker environment