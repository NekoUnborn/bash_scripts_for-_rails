#!/bin/bash

# Validate arguments
if [[ $# -eq 0 ]] ; then
    echo 'add app name as argument'
    exit 1
fi

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# enter directory 
cd ./$1

# Drop databases
echo "Dropping associated databases from $1"
rails db:drop

# cd ..
cd ..

# Delete app
echo "Removing $1 directory"
rm -rf $1

echo "App deleted"
exit 0