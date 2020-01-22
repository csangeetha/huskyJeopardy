#!/bin/bash

cd /home/ghark/git/CS4550proj2/
mix deps.get
cd /home/ghark/git/CS4550proj2/assets
npm install
cd /home/ghark/git/CS4550proj2/


mix phx.digest
PORT=4001 MIX_ENV=dev mix phx.server
