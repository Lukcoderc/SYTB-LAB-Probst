#!/bin/bash

START=$(cat /tmp/time_start.txt)
JETZT=$(date +%s)

echo "Vergangene Zeit: $(( JETZT - START )) Sekunden"
