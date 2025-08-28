# Rootkit Detection – Hidden Files Lab (Scenariusz 3)

## Cel
Nauczyć się wykrywać **ukryte pliki/katalogi** ukrywane przez narzędzia user‑space (np. podmienione `ls`, aliasy) oraz przez „nietypowe” lokalizacje.

## Założenie
To **bezpieczna symulacja** – nic nie modyfikuje kernela. Ukrywamy pliki poprzez alias/funkcję `ls` (user-space), a następnie wykrywamy je różnymi metodami.

---

## Szybki start
```bash
unzip rootkit_detection_hidden_files.zip -d rootkit_detection_hidden_files
cd rootkit_detection_hidden_files

# 1) Uruchom symulator *w bieżącej powłoce* (źródłuj!)
source ./simulate_hidden_files.sh

# 2) Utwórz testowe pliki i zasymuluj „ukrywanie”
./prepare_test_files.sh

# 3) Zobacz różnicę między 'ls' (oszukane) a '/bin/ls' (prawdziwe)
./detect_hidden_files.sh

# 4) (Opcjonalnie) Posprzątaj
./cleanup.sh
```
---

## Co demonstrujemy
- Alias/funkcja `ls` filtruje wpisy zawierające `.rk` oraz `secret*`.
- Różnice między `ls` vs `/bin/ls`, `command ls`, `find`, `stat`.
- Szukanie nietypowych lokalizacji: `/dev`, `/var/tmp`, `/tmp`, katalogi zaczynające się od `.`.
