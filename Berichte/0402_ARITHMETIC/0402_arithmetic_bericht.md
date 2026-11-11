# Bericht: Arithmetic

| | |
|---|---|
| **Fach** | SYTB Übungen |
| **Thema** | Shell-Skript – Arithmetic |
| **Name** | Lukas Eder |
| **Klasse** | 3AHITS |
| **Datum der Übung** | 11.11.2026 |
| **Aufgabenstellung** | https://github.com/HTL-Braunau-probst/SYTB-3-LAB-AHITS24/blob/main/0402_arithmetic_ue.md

## Übung (Multiplizierer)

**Angabe:**
Erstelle ein Skript, das 2 Zahlen als Kommandozeilenargumente übernimmt. Multipliziere diese Zahlen und gib das Ergebnis aus, verwende jede der 3 besprochenen Methoden (let, expr, $(( ))).

**Lösung**

```sh
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
```

## Übung (Werkstatt Summe)

Schreibe ein Skript, das die Summe aller Beträge in [klassenkassa.csv](https://raw.githubusercontent.com/HTL-Braunau-probst/testdata/refs/heads/main/klassenkassa.csv) mit dem Text `Werkstatt` ermittelt.