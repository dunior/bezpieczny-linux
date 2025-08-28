# Rootkit Detection Basic Lab

## Opis
Lab pokazuje proste metody wykrywania ukrywania procesów:
1. Rootkit oparty o moduł jądra (LKM) – symulacja.
2. Rootkit w przestrzeni użytkownika (user-space) – symulacja.

---

## Scenariusz 1 – LKM rootkit
### Instrukcje
1. Uruchom symulator LKM:
   ```bash
   sudo bash simulate_lkm_rootkit.sh
   ```
   Ten skrypt **nie ładuje prawdziwego modułu** – jedynie filtruje wynik `ps`,
   aby zasymulować efekt ukrywania procesu.
2. Uruchom proces:
   ```bash
   yes > /dev/null &
   echo $! > hidden_pid.txt
   ```
3. Sprawdź listę procesów:
   ```bash
   ps aux | grep yes
   ```
4. Porównaj z `/proc`:
   ```bash
   cat hidden_pid.txt
   ls /proc | grep $(cat hidden_pid.txt)
   ```

---

## Scenariusz 2 – User-space rootkit
### Instrukcje
1. Uruchom symulator:
   ```bash
   bash simulate_user_rootkit.sh
   ```
2. Uruchom proces:
   ```bash
   sleep 500 &
   echo $! > hidden_pid.txt
   ```
3. Sprawdź:
   ```bash
   ps aux | grep sleep   # powinien brakować procesu
   ls /proc | grep $(cat hidden_pid.txt)  # PID widoczny
   ```
4. Sprawdź integralność pakietów:
   - Rocky:
     ```bash
     rpm -V procps-ng
     ```
   - Ubuntu:
     ```bash
     sudo apt install debsums
     sudo debsums -s
     ```

---

## Wnioski
- Porównuj dane z narzędzi wysokopoziomowych (`ps`, `ls`) i `/proc`.
- Sprawdzaj integralność pakietów systemowych.
