#!/bin/bash

rm ./db/schema.rb

rails db:reset
rails db:migrate
rails db:seed

echo "complete"
exit 0