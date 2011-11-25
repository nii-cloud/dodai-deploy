#!/bin/bash

CELL_NAME="default"

#shutdown all execd daemons
qconf -ke all

#shutdown qmaster daemon
qconf -km

#remove cell configuration
rm -rf /var/lib/gridengine/$CELL_NAME/
