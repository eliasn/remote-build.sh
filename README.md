# remote-build.sh
A very simple minimalistic bash script for remote building which can be used with ``vim`` without plugins.

## Features
* Uses ``rsync`` to copy files to the build server and ``ssh`` to invoke remote build commands.
* Build server settings (address and port) are stored in a separate dot-file, and you can easily make your VCS ignore it.
* Build command arguments are also stored in a dot-file so you can type them once and then use a keyboard shortcut to start building process. Of course, new arguments given on the command line override those from the dot-file.

## Wishlist
* It would be great to navigate build errors and highlight the corresponding code.

## Usage
1. Place the script into your project directory.
1. Create ``.buildhost`` file which host information in the ``[rsync://]HOST[:PORT]`` format.
1. Run either from the shell: ``./remote-build.sh [ARGS]`` or from vim: ``:!./remote-build.sh [ARGS]``.
1. You can specify arguments to the script, which will be passed to the build command. The arguments are stored in ``.buildargs`` file and are reused if no new arguments are given.
1. Create mappings in ``vim``. For example, to make ``F7`` execute build script with default arguments (taken from ``.buildargs`` if present) and to make ``Shift-F7`` prompt for arguments:

  ```
  map <F7> :!./remote-build.sh
  map <S-F7> :exec "!./remote-build.sh ".input("Optional args: ")<CR>
  ```
  
