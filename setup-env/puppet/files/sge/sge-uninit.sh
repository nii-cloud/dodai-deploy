#!/bin/bash

#shutdown all execd daemons
qconf -ke all

#shutdown qmaster daemon
qconf -km

sleep 10

