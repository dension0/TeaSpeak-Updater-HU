TeaSpeak-updatebackupscript

TeaSpeak update and backup script for Debian linux

Based of Nicer code. Special thanks for:

TeaSpeak updater by Nicer (https://github.com/Najsr/TeaSpeak-Updater)

Tested on Debian

Usege:

download into based of TeaSpeak folder

Add command: chmod u+x updateabackup.sh
Run ./updateabackup.sh

-f / --force - forces update (without prompt) example: -f updateabackup.sh

-p path / --path path Sets working path for the script (otherwise executed in the location of the script) example: -p updateshfoldername updateabackup.sh

-s / --start Starts server after successful update via teastart.sh start (you may add name of script with parameters to change this value) example: -s updateabackup.sh


TeaSpeak frissítő és biztonsági mentést készítő kód a Debian linuxhoz

Nicer kódja alapján. Köszönet a készítőnek:

TeaSpeak frissítő. Készítő Nicer (https://github.com/Najsr/TeaSpeak-Updater)

Debianon tesztelve.

Használat:

Töltse le a TeaSpeak szerver könyvtárába
Parancs: wget https://raw.githubusercontent.com/dension0/TeaSpeak-updatebackupscript/master/updateabackup.sh

Jelenlegi felhasználónak addj engedélyt a fájl futtatására
Parancs: chmod u+x updateabackup.sh

Futasd a fájlt
Parancs: ./updateabackup.sh

Kapcsolók
-f / --force - erőltetett frissítés, frissítés kérdés nélkül (prompt nélkül) példa: -f updateabackup.sh
-p path / --path path A TeaSpeak szerver könyvtárának elérési útja (ha üress a updateabackup.sh fájl könyvtárába frissít) példa: -p updateshfoldername updateabackup.sh
-s / --start A frissítés végeztével a TeaSpeak szerver újraindítása a teastart.sh start parancssal (az érték megváltoztatásához megadható a parancsfájl neve paraméterrel együtt) példa: -s updateabackup.sh
