#!/bin/bash

# This uses the native image management system as a database
rails active_storage:install
rails db:migrate

# add cloudinary gem for methods to assist with uploading and downloading
bundle add cloudinary

# Paring acrive_storage
bundle add activestorage-cloudinary-service

echo "cloudinary:" >> ./config/storage.yml
echo "  service: Cloudinary" >> ./config/storage.yml
echo "  cloud_name: <%= ENV['CLOUDINARY_CLOUD_NAME'] %>" >> ./config/storage.yml
echo "  api_key: <%= ENV['CLOUDINARY_API_KEY'] %>" >> ./config/storage.yml
echo "  api_secret: <%= ENV['CLOUDINARY_API_SECRET'] %>" >> ./config/storage.yml

sed -i "/^  config.active_storage.service = :local.*/r   config.active_storage.service = :cloudinary " >> ./production.rb

echo "add has_one_attached :image_name to the model"