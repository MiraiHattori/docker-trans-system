#!/bin/bash

set -e
docker build --pull -f Dockerfile --tag=choreonoid:m-hattori .
