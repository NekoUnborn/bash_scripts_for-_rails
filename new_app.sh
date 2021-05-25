#!/bin/bash

# Validate arguments
if [[ ! $# -eq 1 ]] ; then
    echo 'add lowercase app name as argument'
    echo 'eg. ./new_app.sh bookclub'
    exit 1
fi

# Create 
printf "\n\nCreating new app\n\n\n"
rails new $1 -d postgresql

# copies new_controller to new folder
# printf "\n\nCopying new_controller.sh to $1 directory\n\n\n"

# enter directory 
cd ./$1

# Adds flexibility to views
sed -i '/^    <%= csp_meta_tag %>.*/a \    \<meta name="viewport" content="width=device-width, initial-scale=1.0">' ./app/views/layouts/application.html.erb

# create local_env.yml
printf "\n\nCreating local_env.yml file\n\n\n"
echo "# Add account settings and API keys here." > ./config/local_env.yml
echo "# This file should be listed in .gitignore to keep your settings secret!" >> ./config/local_env.yml
echo "# Each entry gets set as a local environment variable." >> ./config/local_env.yml
echo "# This file overrides ENV variables in the Unix shell." >> ./config/local_env.yml
echo "# For example, setting:" >> ./config/local_env.yml
echo "# GMAIL_USERNAME: 'Your_Gmail_Username'" >> ./config/local_env.yml
echo "# makes 'Your_Gmail_Username' available as ENV["GMAIL_USERNAME"]" >> ./config/local_env.yml

# Add environmental info to ./config/environments/development.rb
printf "\n\nAdd environmental info to ./config/environments/development.rb\n\n\n"
sed -i '$ d' ./config/environments/development.rb
echo "" >> ./config/environments/development.rb
echo "  env_file = File.join(Rails.root, 'config', 'local_env.yml')" >> ./config/environments/development.rb
echo "  begin" >> ./config/environments/development.rb
echo "    if File.exist?(env_file)" >> ./config/environments/development.rb
echo "      YAML.safe_load(File.open(env_file)).each do |key, value|" >> ./config/environments/development.rb
echo "        ENV[key.to_s] = value" >> ./config/environments/development.rb
echo "      end" >> ./config/environments/development.rb
echo "    end" >> ./config/environments/development.rb
echo "  rescue" >> ./config/environments/development.rb
echo "    nil" >> ./config/environments/development.rb
echo "  end" >> ./config/environments/development.rb
echo "end" >> ./config/environments/development.rb

# add files to .gitignore
printf "\n\nAdding to .gitignore\n\n\n"
echo "# Always add to .gitignore" >> ./.gitignore
echo "/config/local_env.yml" >> ./.gitignore
echo ".env" >> ./.gitignore

# add empty header to application.html.erb
sed -i '/^  <body>.*/a \    \<header>\n    \</header>' ./app/views/layouts/application.html.erb

# add private section to the application_controller.rb
sed -i "/^end.*/i private\n" ./app/controllers/application_controller.rb

# Alter the database.yml
printf "\n\nAdding config to database.yml\n\n\n"
sed -i '/development:/ i \  \username: postgres\n  password: postgres\n  host: localhost\n  port: 5432 ' ./config/database.yml

# setup the database
printf "\n\nSetting up database\n\n\n"
rails db:setup

# Create the basic db setup
printf "\n\nCreating ./db/schema.rb\n\n\n"
rails db:migrate

# add to git
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:NekoUnborn/${1,,}.git
git push -u origin main

# to log into heroku for cli
heroku login
heroku create ${1,,}

# Runs the Rails Server
# printf "\n\nStarting rails server, go to http://localhost:3000 in your browser, cancel server once rails site is shown\n\n\n"
rails s

