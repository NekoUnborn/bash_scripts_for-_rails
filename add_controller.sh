#!/bin/bash

# Validate arguments
if [[ ! $# -eq 2 ]] ; then
    printf 'add plural and singular of controller as arguments'
    printf 'eg. ./new_controller.sh books book'
    exit 1
fi

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# Creating the new controller
printf "\n\nCreating the new controller\n\n"
rails g controller $1

# Adding the resources to routes.rb
printf "\n\nAdding the resources to routes.rb\n\n"
sed -i '$d' ./config/routes.rb
echo "" >> ./config/routes.rb
echo "  get '$1', to: '$1#index', as: '$1'" >> ./config/routes.rb
echo "  post '$1', to: '$1#create'" >> ./config/routes.rb
echo "  get '$1/new', to: '$1#new', as: 'new_$2'" >> ./config/routes.rb
echo "  get '$1/:id', to: '$1#show', as: '$2'" >> ./config/routes.rb
echo "  get '$1/:id/edit', to: '$1#edit', as: 'edit_$2'" >> ./config/routes.rb
echo "  put '$1/:id', to: '$1#update'" >> ./config/routes.rb
echo "  patch '$1/:id', to: '$1#update'" >> ./config/routes.rb
echo "  delete '$1/:id', to: '$1#destroy'" >> ./config/routes.rb
echo "end" >> ./config/routes.rb

# scripting the controller
printf "\n\nScripting the controller\n\n"
sed -i '$d' ./app/controllers/$1_controller.rb
echo "  # DELETE THIS BEFORE RELEASE" >> ./app/controllers/$1_controller.rb
echo "  skip_before_action :verify_authenticity_token, only: %i[create update destroy]" >> ./app/controllers/$1_controller.rb
echo "  before_action :set_$2, only: %i[show update destroy edit]" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb

# Defining the index
echo "  def index" >> ./app/controllers/$1_controller.rb
echo "    @$1 = ${2^}.all" >> ./app/controllers/$1_controller.rb
echo "  end" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb

# defining New
echo "  def new" >> ./app/controllers/$1_controller.rb
echo "    @$2 = ${2^}.new" >> ./app/controllers/$1_controller.rb
echo "  end" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb

# defining create
echo "  def create" >> ./app/controllers/$1_controller.rb
echo "    @$2 = ${2^}.new($2_params)" >> ./app/controllers/$1_controller.rb
echo "    if @$2.save" >> ./app/controllers/$1_controller.rb
echo "      redirect_to @$2" >> ./app/controllers/$1_controller.rb
echo "    else" >> ./app/controllers/$1_controller.rb
echo "      flash.now[:errors] = @$2.errors.full_messages" >> ./app/controllers/$1_controller.rb
echo "      render action: 'new'" >> ./app/controllers/$1_controller.rb
echo "    end" >> ./app/controllers/$1_controller.rb
echo "  end" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb

# defining Show
echo "  def show; end" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb

# defining edit
echo "  def edit; end" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb

#defining update
echo "  def update" >> ./app/controllers/$1_controller.rb
echo "    if @$2.update($2_params)" >> ./app/controllers/$1_controller.rb
echo "      redirect_to @$2" >> ./app/controllers/$1_controller.rb
echo "    else" >> ./app/controllers/$1_controller.rb
echo "      flash.now[:errors] = @$2.errors.full_messages" >> ./app/controllers/$1_controller.rb
echo "      render action: 'edit'" >> ./app/controllers/$1_controller.rb
echo "    end" >> ./app/controllers/$1_controller.rb
echo "  end" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb

# Defining destroy
echo "  def destroy" >> ./app/controllers/$1_controller.rb
echo "    @$2.destroy" >> ./app/controllers/$1_controller.rb
echo "    redirect_to $1_path" >> ./app/controllers/$1_controller.rb
echo "  end" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb

# setting up basic private methods
echo "  private" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb
echo "  def set_$2" >> ./app/controllers/$1_controller.rb
echo "    @$2 = ${2^}.find(params[:id])" >> ./app/controllers/$1_controller.rb
echo "  end" >> ./app/controllers/$1_controller.rb
echo "" >> ./app/controllers/$1_controller.rb
echo "  def $2_params" >> ./app/controllers/$1_controller.rb
echo "    params.require(:${2}).permit(:param1, :param2)" >> ./app/controllers/$1_controller.rb
echo "  end" >> ./app/controllers/$1_controller.rb
echo "end" >> ./app/controllers/$1_controller.rb

# Adding Views
printf "\n\nAdding Views to ./app/views\n\n"

# Adding basic form
printf "\n\nAdding basic _form to ./app/views/_form.html.erb\n\n"
echo "<%= form_with model: @$2, local: true do |f| %>" > ./app/views/$1/_form.html.erb
echo "    <p>" >> ./app/views/$1/_form.html.erb
echo "        <%= f.label :simple1 %>" >> ./app/views/$1/_form.html.erb
echo "        <%= f.text_field :simple1 %>" >> ./app/views/$1/_form.html.erb
echo "    </p>" >> ./app/views/$1/_form.html.erb
echo "    <p>" >> ./app/views/$1/_form.html.erb
echo "        <%= f.label :collection1 %>" >> ./app/views/$1/_form.html.erb
echo "        <%= f.collection_select :collection1_id, @collection1, :id, :column_to_display %>" >> ./app/views/$1/_form.html.erb
echo "    </p>" >> ./app/views/$1/_form.html.erb
echo "    <p>" >> ./app/views/$1/_form.html.erb
echo "        <%= f.label :collection2 %>" >> ./app/views/$1/_form.html.erb
echo "        <%= f.collection_check_boxes :collection2_id, @collection2, :id, :column_to_display %>" >> ./app/views/$1/_form.html.erb
echo "    </p>" >> ./app/views/$1/_form.html.erb
echo "    <p>" >> ./app/views/$1/_form.html.erb
echo "        <%= f.submit %>" >> ./app/views/$1/_form.html.erb
echo "    </p>" >> ./app/views/$1/_form.html.erb
echo "<% end %>" >> ./app/views/$1/_form.html.erb

# Adding index view"
printf "\n\nAdding index view\n\n"
echo "<h1>$1#index</h1>" > ./app/views/$1/index.html.erb
echo "<p>Find me in app/views/$1/index.html.erb</p>" >> ./app/views/$1/index.html.erb
echo "" >> ./app/views/$1/index.html.erb
echo "<p><%= link_to 'New ${2^}', new_$2_path %></p>" >> ./app/views/$1/index.html.erb

# Adding new view
printf "\n\nAdding new view\n\n"
echo "Adding new view"
echo "<h1>$1#new</h1>" > ./app/views/$1/new.html.erb
echo "<p>Find me in app/views/$1/new.html.erb</p>" >> ./app/views/$1/new.html.erb
echo "" >> ./app/views/$1/new.html.erb
echo "<%= render 'form' %>" >> ./app/views/$1/new.html.erb
echo "" >> ./app/views/$1/new.html.erb
echo "<%= link_to 'Cancel', $1_path %>" >> ./app/views/$1/new.html.erb

# Adding edit view
printf "\n\nAdding edit view\n\n"
echo "<h1>$1#edit</h1>" > ./app/views/$1/edit.html.erb
echo "<p>Find me in app/views/$1/edit.html.erb</p>" >> ./app/views/$1/edit.html.erb
echo "" >> ./app/views/$1/edit.html.erb
echo "<%= render 'form' %>" >> ./app/views/$1/edit.html.erb
echo "" >> ./app/views/$1/edit.html.erb
echo "<%= link_to 'Cancel', @$2 %>" >> ./app/views/$1/edit.html.erb

# Adding show view
printf "\n\nAdding show view\n\n"
echo "<h1>$1#show</h1>" > ./app/views/$1/show.html.erb
echo "<p>Find me in app/views/$1/show.html.erb</p>" >> ./app/views/$1/show.html.erb
echo "" >> ./app/views/$1/show.html.erb
echo "<p><%= link_to '<< Back', $1_path %> | <%= link_to 'Edit', edit_$2_path %> | <%= link_to 'Delete', @$2, method: :delete, data: { confirm: 'Are you sure?' } %></p>" >> ./app/views/$1/show.html.erb

echo "Controller created"

git add .
git commit -m "Added $1 controller and basic views"
git push origin main