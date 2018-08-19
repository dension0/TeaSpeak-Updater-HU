# TeaSpeak-Updater

TeaSpeak-Updater szkript használata egyszerű.

Eredeti projekt (köszönet és tisztelet Najsr-nek) [itt](https://github.com/Najsr/TeaSpeak-Updater)

## Kezdés

### Tesztelve az alábbi disztubíciókon
* Debian
* Mint

### Előfeltételek

* Linux disztubíciókon
* curl
* TeaSpeak szerver


### Telepítés

* Legújabb verzió letöltése [itt](https://github.com/dension0/TeaSpeak-Updater-HU/archive/master.zip)
* Kicsomagolás
* Futtatás
* Élvezd

#### vagy telepítés közvetlen fájletöltéssel

* Legújabb verzió letöltése parancssorból: wget https://raw.githubusercontent.com/dension0/TeaSpeak-Updater-HU/master/teaspeak_updater.sh
* Jelenlegi felhasználónak engedély a futtatásra: chmod u+x teaspeak_updater.sh
* Futtatás
* Élvezd

### Parancssor lehetőségei

* __-f / --force__ - erőltetett frissítés, frissítés kérdés nélkül (prompt nélkül) példa: -f teaspeak_updater.sh
* __-p path / --path path__ A TeaSpeak szerver könyvtárának elérési útja (ha üress a teaspeak_updater.sh fájl könyvtárába frissít) példa: -p updateshfoldername teaspeak_updater.sh
* __-s / --start__ A frissítés végeztével a TeaSpeak szerver újraindítása a teastart.sh start parancssal (az érték megváltoztatásához megadható a parancsfájl neve paraméterrel együtt) példa: -s tealoop.sh teaspeak_updater.sh
