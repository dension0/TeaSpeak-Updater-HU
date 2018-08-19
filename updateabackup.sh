#!/bin/bash
#TeaSpeak updater by Nicer
#TeaSpeak updater translated by dension0 (on Forum dension)
#Tested on Debian

#Usege:
#download into based of TeaSpeak folder
#Add command: chmod u+x updateandbackup.sh
#Run ./updateandbackup.sh
#-f / --force - forces update (without prompt) example: -f updateandbackup.sh
#-p path / --path path Sets working path for the script (otherwise executed in the location of the script) example: -p updateshfoldername updateandbackup.sh
#-s / --start Starts server after successful update via teastart.sh start (you may add name of script with parameters to change this value) example: -s updateandbackup.sh

#Használat:
#Töltse le a TeaSpeak szerver könyvtárába
#Parancs: wget https://raw.githubusercontent.com/dension0/TeaSpeak-updatebackupscript/master/updateabackup.sh
#Jelenlegi felhasználónak addj engedélyt a fájl futtatására
#Parancs: chmod u+x updateandbackup.sh
#Futasd a fájlt
#Parancs: ./updateandbackup.sh
#Kapcsolók
#-f / --force - erőltetett frissítés, frissítés kérdés nélkül (prompt nélkül) példa: -f updateandbackup.sh
#-p path / --path path A TeaSpeak szerver könyvtárának elérési útja (ha üress a updateandbackup.sh fájl könyvtárába frissít) példa: -p updateshfoldername updateandbackup.sh
#-s / --start A frissítés végeztével a TeaSpeak szerver újraindítása a teastart.sh start parancssal (az érték megváltoztatásához megadható a parancsfájl neve paraméterrel együtt) példa: -s updateandbackup.sh

#color codes from https://raw.githubusercontent.com/Sporesirius/TeaSpeak-Installer/master/teaspeak_install.sh
function warn() {
    echo -e "\\033[33;1m${@}\033[0m"
}

function error() {
    echo -e "\\033[31;1m${@}\033[0m"
}

function info() {
    echo -e "\\033[36;1m${@}\033[0m"
}

function green() {
    echo -e "\\033[32;1m${@}\033[0m"
}

function cyan() {
    echo -e "\\033[36;1m${@}\033[0m"
}

function red() {
    echo -e "\\033[31;1m${@}\033[0m"
}

function yellow() {
    echo -e "\\033[33;1m${@}\033[0m"
}


#checking for parameters
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -f|--force)
    FORCE="TRUE"
    shift # past argument
    ;;
    -p|--path)
    FOLDER="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--start)
    START="$2"
    shift # past argument
    shift # past value
    if [[ -z $START ]]
    then
      START="teastart.sh start"
    fi
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

#main
if [ -z "$FOLDER" ]
then
        FOLDER="$(dirname "$(readlink -f "$0")")"
else
        if [[ $FOLDER == */ ]]
        then
            FOLDER=${FOLDER:0:(-1)}
        fi
fi

if [ ! -f "$FOLDER/buildVersion.txt" ] 
then
	error "buildVersion.txt not found, cannot proceed with update!";
	exit 1;
fi

if [[ "$(uname -m)" == "x86_64" ]];
then
    arch="amd64"
else
    arch="x86"
fi

latest_version=$(curl -k --silent https://repo.teaspeak.de/server/linux/$arch/latest)
current_version=$(head -n 1 "$FOLDER/buildVersion.txt")
current_version=${current_version:11}

if [[ "$latest_version" == "$current_version" ]];
then
   green "Már a legújabb verziója van telepítve a TeaSpek szervernek. Nincs szükség frissítésre. Nothing to update :)";
   exit 0;
fi

if [[ -z $FORCE ]];
then
	read -n 1 -r -s -p "$(yellow Frissítés elérhető. Kívánja telepíteni? [i/n])"
	echo
	if [[ ! $REPLY =~ ^[Ii]$ ]];
	then
		error "Frissítés megszakítása"
		exit 0;
	fi
else
	info "Új verzió: ($latest_version), frissítési folyamat indítása"
fi

info "Szerver futásának ellenőrzése..."
if [[ $($FOLDER/teastart.sh status) == "Server is running" ]];
then
	info "A szerver jelenleg fut! Leállítás..."
	$FOLDER/teastart.sh stop
fi
info "Biztonsági mentés készítése a jelenlegi szerverről a TeaSpeakBackup_$current_version.tar.gz fájlba"
tar -C $FOLDER/ -zcvf TeaSpeakBackup_$current_version.tar.gz config.yml TeaData.sqlite --overwrite >/dev/null
info "Legújabb verzió letöltése $latest_version";
wget -q -O /tmp/TeaSpeak.tar.gz https://repo.teaspeak.de/server/linux/$arch/TeaSpeak-$latest_version.tar.gz;
info "Kicsomagolás ide: $FOLDER/";
tar -C $FOLDER/ -xzf /tmp/TeaSpeak.tar.gz --overwrite
info "Ideiglenes fájl törlése";
rm /tmp/TeaSpeak.tar.gz
green "A frissítés sikeresen befejezve!";

if [[ ! -z $START ]]
then
  info "Szerver újraindítása";
  $FOLDER/$START;
fi
exit 0;
