# Bericht: Arithmetik

| | |
|---|---|
| **Fach** | SYTB Übungen |
| **Thema** | Shell-Skript – Arithmetik |
| **Name** | Lukas Eder |
| **Klasse** | 3AHITS |
| **Datum der Übung** | 11.11.2026 (ergänzt am 24.11.2026) |
| **Aufgabenstellung** | https://github.com/HTL-Braunau-probst/SYTB-3-LAB-AHITS24/blob/main/0402_arithmetic_ue.md |

---

## 1. Multiplizierer

**Angabe:** Erstelle ein Skript, das 2 Zahlen als Kommandozeilenargumente übernimmt. Multipliziere diese Zahlen und gib das Ergebnis aus, verwende jede der 3 besprochenen Methoden (`let`, `expr`, `$(( ))`).

**Lösung:**

Die Argumente `$1` und `$2` werden auf drei Arten multipliziert. Bei `expr` muss der `*` mit `\*` escaped werden, sonst wird er von der Shell als Wildcard ersetzt.

`multiplizierer.sh`:

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

Ausgabe von `./multiplizierer.sh 6 7`:

```txt
Ergebnis mit let: 42
Ergebnis mit expr: 42
Ergebnis mit $(( )): 42
```

---

## 2. Werkstatt Summe

**Angabe:** Schreibe ein Skript, das die Summe aller Beträge in [klassenkassa.csv](https://raw.githubusercontent.com/HTL-Braunau-probst/testdata/refs/heads/main/klassenkassa.csv) mit dem Text `Werkstatt` ermittelt.

**Lösung:**

`grep` filtert die Werkstatt-Zeilen, `cut -d',' -f3` holt den Betrag (3. Spalte), `paste -sd+` macht daraus `15+13+42+...` und `$(( ))` rechnet die Summe aus.

`werkstatt-summe.sh`:

```sh
#!/bin/bash

summe=$(grep "Werkstatt" klassenkassa.csv | cut -d',' -f3 | paste -sd+)

ergebnis=$((summe))

echo "Summe: $ergebnis"
```

Ausgabe:

```txt
Summe: 397
```

Achtung: Die 2. Spalte ist das Datum, der Betrag steht erst in der 3. Spalte.

---

## 3. Zeitmessung

**Angabe:** Schreibe 2 Skripts: `time_start.sh` und `time_stop.sh`. Bei Aufruf von `time_stop.sh` wird die Anzahl der Sekunden ausgegeben, die seit dem letzten Aufruf von `time_start.sh` vergangen sind.

**Lösung:**

`time_start.sh` speichert die aktuelle Zeit in Sekunden (`date +%s`) in einer Datei. `time_stop.sh` liest sie wieder aus und zieht sie von der aktuellen Zeit ab.

`time_start.sh`:

```sh
#!/bin/bash

date +%s > /tmp/time_start.txt
echo "Zeitmessung gestartet"
```

`time_stop.sh`:

```sh
#!/bin/bash

START=$(cat /tmp/time_start.txt)
JETZT=$(date +%s)

echo "Vergangene Zeit: $(( JETZT - START )) Sekunden"
```

Ausgabe (3 Sekunden gewartet):

```txt
Zeitmessung gestartet
Vergangene Zeit: 3 Sekunden
```

---

## 4. Zufallszahl

**Angabe:** Schreibe ein Skript `random.sh`, bei dem über 2 Grenzen (Argumente) der gewünschte Wertebereich vorgegeben werden kann. Zum Beispiel generiert `./random.sh 10 45` eine zufällige Zahl im Bereich von 10 bis 45 (jeweils inklusive).

**Lösung:**

`RANDOM % (MAX - MIN + 1)` liefert Werte von `0` bis `MAX - MIN`. Mit `+ MIN` wird der Bereich nach oben verschoben. Das `+ 1` sorgt dafür, dass auch `MAX` selbst vorkommen kann.

`random.sh`:

```sh
#!/bin/bash

MIN=$1
MAX=$2

echo $(( RANDOM % (MAX - MIN + 1) + MIN ))
```

Ausgabe (drei Aufrufe von `./random.sh 10 45`):

```txt
10
10
21
```

Test: Bei 2000 Aufrufen war die kleinste Zahl `10` und die größte `45`.
