# Symulacja ukrywania plików przez LD_PRELOAD

Ten kod C tworzy bibliotekę współdzieloną, która nadpisuje `readdir()`,
filtrując wpisy zawierające `.rk` lub zaczynające się od `secret`.

## Budowanie
```bash
gcc -shared -fPIC -o hidefiles.so hidefiles.c -ldl
```

## Użycie
```bash
LD_PRELOAD=$PWD/hidefiles.so ls -la /tmp/rk_lab_hidden
```

Pliki `.rk` i `secret*` nie będą widoczne w tym wywołaniu `ls`.

## Wykrywanie
- Uruchom `/bin/ls` bez LD_PRELOAD
- Sprawdź zmienną środowiskową `LD_PRELOAD`
- Porównaj `strace ls` z i bez LD_PRELOAD
