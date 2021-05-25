#!/bin/bash

# Validate arguments
if [[ ! $# -eq 2 ]] ; then
    printf 'add the name of your Roles model and Users model as arguments'
    printf 'eg. ./add_roles.sh role user'
    exit 1
fi

# Install Rolify for roles
# https://github.com/RolifyCommunity/rolify

bundle add rolify

rails g rolify ${1^} ${2^}

rails db:migrate

# add :user defult role to rolify
sed -i "/^  rolify.*/a \ \ after_create :assign_default_role" ./app/models/user.rb
sed -i '$d' ./app/models/user.rb
echo "  def assign_default_role" >> ./app/models/user.rb
echo "    add_role(:user) if roles.blank?" >> ./app/models/user.rb
echo "  end" >> ./app/models/user.rb
echo "end" >> ./app/models/user.rb

# add Roles routes to routes.rb
sed -i '$d' ./config/routes.rb
echo "" >> ./config/routes.rb
echo "#  get '$1s', to: '$1s#index', as: '$1s'" >> ./config/routes.rb
echo "#  post '$1s', to: '$1s#create'" >> ./config/routes.rb
echo "#  get '$1s/new', to: '$1s#new', as: 'new_$1'" >> ./config/routes.rb
echo "#  get '$1s/:id', to: '$1s#show', as: '$1'" >> ./config/routes.rb
echo "#  get '$1s/:id/edit', to: '$1s#edit', as: 'edit_$1'" >> ./config/routes.rb
echo "#  put '$1s/:id', to: '$1s#update'" >> ./config/routes.rb
echo "#  patch '$1s/:id', to: '$1s#update'" >> ./config/routes.rb
echo "#  delete '$1s/:id', to: '$1s#destroy'" >> ./config/routes.rb
echo "end" >> ./config/routes.rb

git add .
git commit -m "Added rolify"
git push origin main

# add policies to roles (pundit)
# https://github.com/varvet/pundit

bundle add pundit

# add error handling to application_controller.rb
sed -i "/^class ApplicationController < ActionController::Base.*/a \  \include Pundit\nrescue_from Pundit::NotAuthorizedError, with: :forbidden" ./app/controllers/application_controller.rb
sed -i "/^private.*/a \  \def forbidden\n    flash[:alert] = 'you are not authorised to perform that action'\n    redirect_to request.referrer || root_path\n  end" ./app/controllers/application_controller.rb

rails g pundit:install

git add .
git commit -m "Added Pundit"
git push origin main