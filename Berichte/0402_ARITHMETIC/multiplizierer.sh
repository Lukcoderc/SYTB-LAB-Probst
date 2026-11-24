#!/bin/bash

zahl1=$1
zahl2=$2

#Mit let
let ergebnis1=zahl1*zahl2
echo "Ergebnis mit let: $ergebnis1"

#Mit expr
ergebnis2=$(expr $zahl1 \* $zahl2)
echo "Ergebnis mit expr: $ergebnis2"

#Mit $(( ))
ergebnis3=$((zahl1 * zahl2))
echo "Ergebnis mit \$(( )): $ergebnis3"