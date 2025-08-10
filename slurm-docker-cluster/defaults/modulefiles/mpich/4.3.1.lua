-- module description for mpich-4.3.1

conflict("mpi")

help ( [[
    MPICH is a high-performance and widely portable implementation of the Message Passing Interface (MPI) standard (MPI-1, MPI-2, MPI-3, and MPI-4).
    MPICH is distributed as source (with an open-source, freely available license). It has been tested on several platforms, including Linux (on IA32 and x86-64), macOS, and FreeBSD.
    
    Built with: gcc
    ---------------------------------------------
    More Info: https://www.mpich.org/about/overview/
]])
whatis("Sets up environment for MPICH version 4.3.1")



local prefix = "/opt/mpich/4.3.1"

-- pathJoin is provided by lmod
-- https://lmod.readthedocs.io/en/latest/050_lua_modulefiles.html#

-- Setting some of the paths as available in frontier
prepend_path("PATH", pathJoin(prefix, "bin"))

-- MPICH_HOME for accessing MPICH root dir
setenv("MPICH_HOME", prefix)

-- For providing access to library inside mpich
prepend_path("LD_LIBRARY_PATH", pathJoin(prefix, "lib") )

-- https://man7.org/linux/man-pages/man5/manpath.5.html
prepend_path("MANPATH", pathJoin(prefix, "share/man"))
