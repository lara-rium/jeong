#! /usr/bin/sh

export MIX_ENV=prod

git pull
mix phx.gen.release
mix deps.get --only prod
mix assets.setup
mix assets.deploy
mix release

sudo systemctl stop jeong
sudo cp -a _build/prod/rel/jeong/. /opt/jeong/

sudo systemd-run --wait --pipe --collect \
  --property=User=jeong \
  --property=Group=jeong \
  --property=EnvironmentFile=/etc/jeong.env \
  /opt/jeong/bin/migrate

sudo systemctl start jeong
