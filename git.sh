#!/bin/bash

# Validate arguments
if [[ $# -eq 0 ]] ; then
    echo 'add comment as argument'
    exit 1
fi
str="$*"

# upload to Github
git add .
git commit -m "$str"
git push origin main

# to heroku
# git push heroku main