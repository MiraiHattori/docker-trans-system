#!/bin/bash

set -e
docker build --pull -f Dockerfile --tag=jaxontennis:m-hattori .
