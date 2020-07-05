#!/bin/bash

set -e
docker build -f Dockerfile --tag=isk-solver:m-hattori .
# docker build --pull -f Dockerfile --tag=choreonoid:m-hattori .
