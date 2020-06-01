#!/bin/bash

container="choreonoidsim"

EXE=${@:-"/bin/bash"}

docker exec -it \
    ${container} ${EXE}
