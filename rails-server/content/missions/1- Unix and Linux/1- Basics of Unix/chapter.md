---
title: Basics of Unix
description: A short summary of this chapter
contributors: Ilya Zhukov, Bishwo Dahal
duration_minutes: 10
---


# Unix shell basics

Whether you log in via OpenSSH, PuTTY, or opening a Terminal in JupyterLab, you will be interacting with the system through a [Unix shell](https://en.wikipedia.org/wiki/Unix_shell).
Unix shells are text based interfaces that prompt the user to input commands and display the result of executing those commands back to the user.
The underlying concepts (the file system, executing programs, etc.) are probably familiar to you, but the text based interface can seem daunting at first.
This section will teach you how to accomplish essential tasks on a Unix shell.
If you are already familiar with this kind of interface, you may want to skip ahead to the [section describing the environment](environment.md).

Like many operating systems, Unix provides an abstraction for storage media called a file system.
Data of various types (text, images, executable code, etc.) is stored in files which can be organized in a tree-like hierarchy of directories that starts at a single root (the "root directory").
Objects in the file system (files or directories) are addressed using strings of characters called "paths" that list the directories one has to traverse to get to an object plus the objects name.
The slash `/` serves as the separator between elements of a path and cannot itself appear in file or directory names. 
Some examples for paths are:

```
/etc
/usr/bin/env
/home/bsteinb/Documents
```

These paths are all "absolute paths", meaning, they describe the location of an objects in relation to the root directory (which is represented by a single slash `/`):

- `etc` is a directory that is found inside of the root directory
- `env` is a file found in the directory `bin` which itself is found in the directory `usr` inside the root directory
- `Documents` is a directory in `bsteinb` which is a directory in `home` which is a directory in the root directory

Since absolute paths can become unwieldy in deep directory hierarchies, Unix also allows relative paths.
To this end, every program (including the shell you are using) is executed in a "working directory" (which can be changed during the execution of the program).
Relative path specifications are then interpreted in relation to this working directory.
They are written without the initial slash `/`.
Some examples for relative paths are:

```
Documents
bin/env
../etc/crontab
```

With a working directory of `/usr`, `bin/env` refers to `/usr/bin/env`, just like the absolute path above.
The path component `..` above has a special function.
It refers to the parent (the containing directory) of a file system object and can appear in both relative and absolute paths.
So `../etc/crontab` refers to a file `crontab` in a directory `etc` that can be found in the parent directory of the current working directory.
`/home/bsteinb/../janedoe/.bashrc` can be simplified to `/home/janedoe/.bashrc`.

To find out the current working directory of the shell you are using, type:

```
$ pwd
```

The output should be something like:

```
/p/home/jusers/steinbusch1/juwels
```

which is the "home directory" associated with your account on the system.
To list the contents of the working directory, execute the `ls` command:

```
$ ls
```

If you are working with a fresh user account, the output of this command might be empty, because there are no files (or only hidden files) in your home directory.
To make `ls` display the hidden files as well, add the optional argument `-a`:

```
$ ls -a
```

The output should now be non-empty and contain files and directories with names that start with the period `.`.
In Unix, whether a file system item is hidden or not is determined by the first character in its name being the period `.`.

`ls -a` is our first example of a more complex command invocation.
It starts with the name of a command (so far, we have seen `pwd` and `ls`) followed by a list of arguments (here `-a`), all separated by spaces.
`ls` can be used to list the contents of any directory, by specifying the path of the directory in the last position.
To list the items in the `/etc` directory, type:

```
$ ls /etc
```

Most commands and the list of arguments they accept are documented in the Unix manual pages.
They can be accessed through a command – `man` – that takes as its only argument the name of the manual page you want to read.
For most commands there is a manual page with the same name as the command.
To read the manual page for `ls`, type:

```
$ man ls
```

You can scroll through the manual page using the arrow keys.
When you are done reading, close the manual by pressing `q` on the keyboard.
To find manual pages for a specific topic, you can use the `apropos` command which searches the library of manual pages for a given keyword.

To change the working directory of your shell and all commands you invoke subsequently, use the `cd` command:

```
$ cd /
```

This will take you to the root directory.
If you now execute `ls` without specifying a path, it should show you all items in the root directory, e.g.:

```
$ ls
arch   bin   dev  gpfs  lib    media  opt  proc  run   selinux  sys  usr
arch2  boot  etc  home  lib64  mnt    p    root  sbin  srv      tmp  var
```

Invoking `cd` without an argument takes you back to your home directory:

```
$ cd
$ pwd
/p/home/jusers/steinbusch1/juwels
```

Alternatively, the path to your home directory is also availably as the value of an "environment variable".
Environment variables map names (strings) to values (also strings) and can be seen as implicit input to commands while arguments on the command line are explicit inputs.
The name of the environment variable that contains the path to your home directory is `HOME`.
Its value can be inspected using the `printenv` command:

```
$ printenv HOME
/p/home/jusers/steinbusch1/juwels
```

The `printenv` command asks the environment for the value of the variable `HOME` (using the `getenv` function) and prints it to the terminal.
In some situations it makes sense, to use the value of environment variables as explicit arguments to a command (e.g. if you want to `cd` to the value of `HOME`).
This is supported by a shell mechanism called "variable expansion": mention the name of a variable, prefixed by the dollar sign `$` in a command line and the shell will substitute the value of the variable and pass that as an argument to the command:

```
$ cd $HOME
$ pwd
/p/home/jusers/steinbusch1/juwels
```

The `env` command can be used to inspect the environment.
When invoked without any arguments it prints a list of all variables currently defined and their values.

```
$ env
[...]
HOME=/p/home/jusers/steinbusch1/juwels
[...]
```

`pwd`, `cd` and `ls` let you navigate the file system.
The following commands can be used to make modifications to the file system.
First is `mkdir` which allows you to make a directory:

```
mkdir <directory_path>
```

To create an empty file at a given location, use:

```
touch <file_path>
```

In your home directory, create two directories and a file:

```
$ mkdir dir1 dir2
$ touch dir1/file1
```

You can use `ls` to confirm that you have created two directories next to each other, one of which contains an empty file.

```
$ ls
dir1 dir2
$ ls dir1
file1
$ ls dir2
```

Files and directories can be moved, copied and deleted with the commands:

```
$ mv <source_path> <destination_path>
$ cp -r <source_path> <destination_path>
$ rm -r <path>
```

Make a copy of `dir1` and check that it also contains `file1`.

```
$ cp -r dir1 dir3
$ ls dir3
file1
```

Move the copy of the file into `dir2`.

```
$ mv dir3/file1 dir2
$ ls dir2
file1
$ ls dir3
```

Finally, remove all three directories.

```
$ rm -r dir1 dir2 dir3
$ ls
```

Lastly, we will mention one way of editing text files: the `nano` editor.
To open a file in `nano`, type:

```
$ module load nano
$ nano <file_path>
```

(The `module` command will be explained in detail later on.)

To insert something into the file, just start typing.
Save your changes by pressing *CTRL-O*.
Exit the editor by pressing *CTRL-X*.
The bottom part of the terminal will display more functions which can be reached using certain key bindings.
Interaction with the editor, such as specifying a file name when saving, will also happen here.

## Change permissions with chmod

To change access permissions for files and directories one can use the `chmod` command. Through the `ls -l` command one can display the current access rights to a file or directory, which will look as follows:

```
-rwxr-xr-x 1 zjupa1 jusers 26080 May 10 16:58 <file>
drwxr-xr-x 5 zjupa1 jusers  4096 May 11 15:52 <dir>
```

The entries from left to right are: access rights, number of files, owner (user), group, size, date of last interaction, file or directory name. The first character in the access rights entry is either a hyphon `-` for files (first line above) or `d` for directories (second line above), followed by three blocks of three characters each: `r`, `w`, and `x` which specify the read, write, and execute access, respectively. A hyphon `-` then means that access is not granted. The first block of three characters specifies the access for the *user* (owner, here: `zjupa1`), the second for the *group* (that owns that file or directory, here: `jusers`), the third for all *others*. For above examples the *user* has all rights, while the *group* and *others* can read and execute but not write.

Access permissions can be changed in either symbolic or numeric mode.

### Symbolic mode

In the symbolic mode `chmod` has following syntax:

```
$ chmod [references][operator][modes] <file>/<dir>
```

where references can be `u` for the *user*, `g` for the *group*, `o` for *others*, or `a` for *all*. The operator is either `+` to give a right, `-` to remove a right, or `=` to set rights exactly as specified. Modes are the three access rights `r`, `w`, `x`. Applied to above example

```
$ chmod g+w <file>
```

gives the *group* write rights and result to

```
-rwxrwxr-x 1 zjupa1 jusers 26080 May 10 16:59 <file>
```

while doing

```
$ chmod ug=rx <file>
```

results in

```
-r-xr-x--- 1 zjupa1 jusers 26080 May 10 16:59 <file>
```

### Numeric mode

The modes of access rights can also be given in a numeric notation following the syntax

```
$ chmod [numeric notation] <file>/<dir>
```

For a list of numeric values and their translation to `r`, `w`, and `x` access rights for the *user*, *group*, and *others*, as well as for further reference you can consult [here](https://ss64.com/bash/chmod.html).

#### Inspired from tutorial here:
https://zhukov1.pages.jsc.fz-juelich.de/intro2sc-handson/2025_05/docs/unix-shell-basics