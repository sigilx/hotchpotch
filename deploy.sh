#!/usr/bin/env bash

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
cd assets
node node_modules/brunch/bin/brunch  build --production
cd ..
MIX_ENV=prod mix phoenix.digest

# Custom tasks (like DB migrations)ZZ
MIX_ENV=prod mix ecto.migrate

# Finally run the server
MIX_ENV=prod PORT=4321 elixir --detached -S mix phx.server