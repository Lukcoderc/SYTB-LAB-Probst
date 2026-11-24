#!/bin/bash

MIN=$1
MAX=$2

echo $(( RANDOM % (MAX - MIN + 1) + MIN ))
