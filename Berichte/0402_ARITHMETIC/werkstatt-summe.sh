#!/bin/bash

summe=$(grep "Werkstatt" klassenkassa.csv | cut -d',' -f2 | paste -sd+)

ergebnis=$((summe))

echo "Summe: $ergebnis"