# Bericht: Command Substitution

| | |
|---|---|
| **Fach** | SYTB Übungen |
| **Thema** | Shell-Skript – Command Substitution |
| **Name** | Lukas Eder |
| **Klasse** | 3AHITS |
| **Datum der Übung** | 21.10.2026 |
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

Das Balldatum liegt in der Variable `BALL_DATUM`. Über Command Substitution `$(...)` speichere ich die Ausgabe von `date` in weiteren Variablen: einmal die aktuelle Zeit (`date +%s`), einmal die Zeit des Balls (`date --date="$BALL_DATUM" +%s`), beides in Sekunden seit 1970. Die Differenz wird mit `$(( ))` berechnet und durch 86400 geteilt (so viele Sekunden hat ein Tag), das ergibt die verbleibenden Tage.

`ball.sh`:

```sh
#!/bin/bash

BALL_DATUM="2027-01-15"

JETZT=$(date +%s)
BALL=$(date --date="$BALL_DATUM" +%s)

TAGE=$(( (BALL - JETZT) / 86400 ))

# Ausgabe
echo "Es sind noch $TAGE Tage bis zum HTL Ball ($BALL_DATUM)"
```

Beim Schreiben ist mir aufgefallen: `--date` darf kein Leerzeichen enthalten, und `$(( ... ))` muss mit `))` geschlossen werden, sonst kommt ein Syntaxfehler.

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

Nicht möglich, die Wortliste herunterzuladen.

---

## 3. Datierte Kopie V1

**Angabe:** Schreibe ein Skript, das einen Dateinamen als erstes Argument übernimmt und eine datierte Kopie der Datei anlegt. Heißt die Datei z.B. `file1.txt` und ist heute der 2026-10-13, so soll die Kopie `2026-10-13_file1.txt` heißen.

Hinweis: Verwende Command Substitution und das Kommando `date`.

**Lösung:**

Der Dateiname kommt als erstes Argument (`$1`). `date +%F` liefert das heutige Datum als `JJJJ-MM-TT`, das über `$(...)` in `DATUM` landet. `cp` legt dann die Kopie mit dem Namen `<Datum>_<Dateiname>` an. Die geschweiften Klammern bei `${DATUM}` sorgen dafür, dass der Unterstrich nicht zum Variablennamen gezählt wird.

`datierte_kopie.sh`:

```sh
#!/bin/bash

DATUM=$(date +%F)
cp "$1" "${DATUM}_$1"
```

Aufruf: `./datierte_kopie.sh file1.txt` erzeugt z.B. `2026-10-13_file1.txt`.
