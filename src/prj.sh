#!/bin/bash

# Path to here, where the prj library lives.
HERE=$(dirname $BASH_SOURCE)

# Prj entry point script, responsible for loading all library
# functions and commands necessary for the user to operate prj from
# the shell.
#
# This script's only side effect will be to load the prj library
# itself, UNLESS the PRJ environment variable is set, in which case
# its value will be passed to prj-load.

# Path to command scripts.
COMMANDS=$HERE/commands

# Path to common library functionality
LIB=$HERE/lib.sh

# Verbose mode?
VERBOSE=0

. $LIB
load_commands $COMMANDS

# If a project is already set, load that project
if [ "$PRJ" != "" ]
then
    SILENT=1 prj-reload
fi