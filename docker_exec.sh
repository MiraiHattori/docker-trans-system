#!/bin/bash

container="jaxontennis"

EXE=${@:-"/bin/bash --rcfile /userdir/my_entryrc"}

docker exec -it \
    ${container} ${EXE}
