#!/bin/bash

container="isk-solver"

EXE=${@:-"/bin/bash"}

docker exec -it \
    ${container} ${EXE}
