#!/bin/bash

summe=$(grep "Werkstatt" klassenkassa.csv | cut -d',' -f3 | paste -sd+)

ergebnis=$((summe))

echo "Summe: $ergebnis"