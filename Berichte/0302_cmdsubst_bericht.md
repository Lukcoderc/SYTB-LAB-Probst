# Bericht: Command Substitution

| | |
|---|---|
| **Fach** | SYTB Übungen |
| **Thema** | Shell-Skript – Command Substitution |
| **Name** | Lukas Eder |
| **Klasse** | 3AHITS |
| **Datum der Übung** | 21.10.2026 (ergänzt am 10.11.2026) |
| **Aufgabenstellung** | Angabe im Unterricht; Wortliste für Übung 2: [wordlist.txt](https://raw.githubusercontent.com/HTL-Braunau-probst/testdata/refs/heads/main/wordlist.txt) |

---

## 1. Tage bis zum HTL Ball

**Angabe:** Schreibe ein Shell-Skript, das die Anzahl der Tage bis zum HTL Ball ermittelt. Das Datum des Balls soll am Anfang des Skripts in einer Variable stehen. Die Ausgabe soll in der folgenden Form sein:

```txt
Es sind noch 94 Tage bis zum HTL Ball (2027-01-15)
```

Hinweise:

- Rechne mit dem `date` Format `seconds since the Epoch (1970-01-01 00:00 UTC)`, siehe `date +%s`.
- Mit `date --date=...` kann ein beliebiges Datum statt dem aktuellen verwendet werden, z.B. `date --date=2027-01-15 +%s`.

**Lösung:**

Mit `date +%s` hole ich die aktuelle Zeit und die Zeit des Balls in Sekunden. Die Differenz teile ich durch 86400 (Sekunden pro Tag), das ergibt die Tage.

`ball.sh`:

```sh
#!/bin/bash

BALL_DATUM="2027-01-15"

JETZT=$(date +%s)
BALL=$(date --date="$BALL_DATUM" +%s)

TAGE=$(( (BALL - JETZT) / 86400 ))

echo "Es sind noch $TAGE Tage bis zum HTL Ball ($BALL_DATUM)"
```

Ausgabe (am 10.11.2026):

```txt
Es sind noch 65 Tage bis zum HTL Ball (2027-01-15)
```

Achtung: `$(( ... ))` muss mit `))` geschlossen werden, sonst gibt es einen Syntaxfehler.

---

## 2. Zufälliger Satz

**Angabe:** Erstelle ein Skript, das einen Satz aus 5 zufälligen Wörtern bildet, z.B.:

```txt
richtig ganzen Kilometer auf Mittel
```

Wähle die Wörter aus dieser Wortliste: [Wörter](https://raw.githubusercontent.com/HTL-Braunau-probst/testdata/refs/heads/main/wordlist.txt)

- Lade die Wortliste mit `wget` herunter.
- Das Skript soll auch die Anzahl der in der Wortliste enthaltenen Wörter ermitteln. D.h. die Konstante 1000 soll im Skript nicht vorkommen.

Hinweise:

- Das Kommando `sed -n 5p datei.txt` gibt bspw. nur die 5. Zeile aus.
- `$RANDOM` liefert eine Zufallszahl. Achtung: `#!/bin/bash` in der she-bang Zeile verwenden, `sh` unterstützt kein `$RANDOM`.
- `$(( RANDOM % N ))` liefert Werte von `0` bis `N-1` – die Zeilennummern bei `sed` beginnen aber bei `1`.

**Lösung:**

`wget` lädt die Wortliste, `wc -l` zählt die Wörter. Für jedes Wort wird mit `$RANDOM` eine Zeilennummer gewählt (`+ 1`, weil `sed` bei 1 zu zählen beginnt) und mit `sed -n` diese Zeile ausgegeben.

`satz.sh`:

```sh
#!/bin/bash

DATEI="wordlist.txt"

# Wortliste nur herunterladen, wenn sie noch nicht da ist
if [ ! -f "$DATEI" ]; then
    wget -q https://raw.githubusercontent.com/HTL-Braunau-probst/testdata/refs/heads/main/wordlist.txt -O "$DATEI"
fi

ANZAHL=$(wc -l < "$DATEI")

W1=$(sed -n "$(( RANDOM % ANZAHL + 1 ))p" "$DATEI")
W2=$(sed -n "$(( RANDOM % ANZAHL + 1 ))p" "$DATEI")
W3=$(sed -n "$(( RANDOM % ANZAHL + 1 ))p" "$DATEI")
W4=$(sed -n "$(( RANDOM % ANZAHL + 1 ))p" "$DATEI")
W5=$(sed -n "$(( RANDOM % ANZAHL + 1 ))p" "$DATEI")

echo "$W1 $W2 $W3 $W4 $W5"
```

Ausgabe (zwei Aufrufe):

```txt
DM bis allerdings bringen Grünen
Jahren schließlich stellte Ich besteht
```

Bei `wc -l < datei` kommt nur die Zahl raus, ohne den Dateinamen.

---

## 3. Datierte Kopie V1

**Angabe:** Schreibe ein Skript, das einen Dateinamen als erstes Argument übernimmt und eine datierte Kopie der Datei anlegt. Heißt die Datei z.B. `file1.txt` und ist heute der 2026-10-13, so soll die Kopie `2026-10-13_file1.txt` heißen.

Hinweis: Verwende Command Substitution und das Kommando `date`.

**Lösung:**

`date +%F` liefert das Datum als `JJJJ-MM-TT`. `cp` kopiert die Datei mit dem Datum vorne im Namen.

`datierte_kopie.sh`:

```sh
#!/bin/bash

DATUM=$(date +%F)
cp "$1" "${DATUM}_$1"
```

Aufruf: `./datierte_kopie.sh file1.txt` erzeugt z.B. `2026-10-13_file1.txt`.

---

## 4. Datierte Kopie V2

**Angabe:** Erweitere das Skript so, dass das Datum nach dem Dateinamen und vor der Endung steht, z.B. `file1_2026-10-13.txt`.

Hinweis: Verwende `cut`, um den Dateinamen von der Endung zu trennen, z.B. `echo "filename.ext" | cut ...`

Überlege: Was passiert bei Dateien wie `archiv.tar.gz` oder `README` (ohne Endung)?

**Lösung:**

`cut -d. -f1` gibt den Namen vor dem ersten Punkt aus, `cut -d. -f2-` die Endung danach. Hat die Datei keine Endung, wird das Datum einfach angehängt.

`kopie_v2.sh`:

```sh
#!/bin/bash

DATUM=$(date +%F)
NAME=$(echo "$1" | cut -d. -f1)
ENDUNG=$(echo "$1" | cut -d. -f2-)

if [ "$NAME" = "$1" ]; then
    # keine Endung (z.B. README)
    cp "$1" "${NAME}_${DATUM}"
else
    cp "$1" "${NAME}_${DATUM}.${ENDUNG}"
fi
```

Test:

| Original | Kopie |
|---|---|
| `file1.txt` | `file1_2026-11-10.txt` |
| `archiv.tar.gz` | `archiv_2026-11-10.tar.gz` |
| `README` | `README_2026-11-10` |

Bei `archiv.tar.gz` bleibt dank `-f2-` die ganze Endung `tar.gz` erhalten. Bei `README` gibt es keinen Punkt, darum wird das Datum nur hinten angehängt.

---

## 5. Datierte Kopie V3

**Angabe:** Erweitere das Skript aus V2 so, dass es eine beliebige Anzahl von Dateien als Argumente akzeptiert und von jeder eine datierte Kopie anlegt.

Hinweis: Verwende `$@` (siehe Kapitel Argumentliste). Alternativ kann auch das Kommando `xargs` nützlich sein.

**Lösung:**

Gleicher Code wie V2, nur in einer `for`-Schleife über alle Argumente (`"$@"`).

`kopie_v3.sh`:

```sh
#!/bin/bash

DATUM=$(date +%F)

for DATEI in "$@"; do
    NAME=$(echo "$DATEI" | cut -d. -f1)
    ENDUNG=$(echo "$DATEI" | cut -d. -f2-)

    if [ "$NAME" = "$DATEI" ]; then
        cp "$DATEI" "${NAME}_${DATUM}"
    else
        cp "$DATEI" "${NAME}_${DATUM}.${ENDUNG}"
    fi
done
```

Test: `./kopie_v3.sh a.txt b.md archiv.tar.gz README` erzeugt:

```txt
README_2026-11-10
a_2026-11-10.txt
archiv_2026-11-10.tar.gz
b_2026-11-10.md
```
