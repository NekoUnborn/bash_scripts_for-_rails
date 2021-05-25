#!/bin/bash

# Add devise to bundle
# https://github.com/heartcombo/devise
bundle add devise

# run the generator
rails generate devise:install

# "add the mailer to development.rb"
sed -i "/^  # Don't care if the mailer can't send.*/a \ \ config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }" ./config/environments/development.rb

# add the following to app/views/layouts/application.html.erb
sed -i '/^    <\/header>.*/a \      \<% if notice %>\n      \<p class="notice"><%= notice %></p>\n    \<% end %>\n    \<% if alert %>\n      \<p class="alert"><%= alert %></p>\n    \<% end %>' ./app/views/layouts/application.html.erb

rails g devise user

rails db:migrate

rails g devise:views

git add .
git commit -m "Added Devise"
git push origin main