#!/bin/bash
#TeaSpeak updater by Nicer (https://github.com/Najsr/TeaSpeak-Updater)
#TeaSpeak Updater by essemX (github.com/essemX/teaspeak-updatescript)
#Tested on Debian

#Usege:
#download into based of TeaSpeak folder
#Add command: chmod u+x autoupdateandbackup.sh
#Run ./autoupdateandbackup.sh
#-f / --force - forces update (without prompt) example: -f autoupdateandbackup.sh
#-p path / --path path Sets working path for the script (otherwise executed in the location of the script) example: -p updateshfoldername autoupdateandbackup.sh
#-s / --start Starts server after successful update via teastart.sh start (you may add name of script with parameters to change this value) example: -s autoupdateandbackup.sh

echo "############### TeaSpeak Updater by dension (based code of Nicer and essemX. THX!) ###############"

#Define section - start

#define save folder name
SAVEFOLDER = "saves"

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
	echo "buildVersion.txt not found, cannot proceed with update!";
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
#Define section - stop

#No need update section - start
if [[ "$latest_version" == "$current_version" ]];
then
   echo "##### You are already using latest version of TeaSpeak. Nothing to update :) #####";
   exit 0;
fi
#No need update section - stop

#Forced update section - start
if [[ -z $FORCE ]];
then
	read -p "# An update is available, do you want to update?" -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]];
	then
		echo "# Aborting update..."
		exit 0;
	fi
else
	echo "##### Found new version ($latest_version), starting update #####";
fi
#Forced update section - stop

#Stop TeaSpeak server if runing section - start
echo "##### Checking for running server #####"
if [[ $($FOLDER/teastart.sh status) == "Server is running" ]];
then
	echo "# Server is still running! Shutting it down..."
	$FOLDER/teastart.sh stop
	echo "# Ready"
fi
#Stop TeaSpeak server if runing section - stop

#Download update section - start
echo "##### Downloading server version $latest_version #####";
wget -q -O /tmp/TeaSpeak.tar.gz https://repo.teaspeak.de/server/linux/$arch/TeaSpeak-$latest_version.tar.gz;
echo "# Ready";
#Download update section - stop

#Backup section - start
echo "##### Saving current config file and database into $SAVEFOLDER/$current_version folder#####";
cp $FOLDER/config.yml $FOLDER/config.yml.old;
cp $FOLDER/TeaData.sqlite $FOLDER/TeaData.sqlite.old;
if [ ! -d "$FOLDER/$SAVEFOLDER" ];
then
	mkdir $FOLDER/$SAVEFOLDER
	echo "# Creating $FOLDER/$SAVEFOLDER folder succesfull!"
else
	echo "# Creating ($FOLDER/$SAVEFOLDER) folder unsuccesfull!"
fi

if [ ! -d "$FOLDER/$SAVEFOLDER/$current_version" ];
then
	mkdir $FOLDER/$SAVEFOLDER/$current_version
	echo "# Creating ($FOLDER/$SAVEFOLDER/$current_version) subfolder succesfull!"
else
	echo "# Creating ($FOLDER/$SAVEFOLDER/$current_version) subfolder unsuccesfull!"
fi

if [ -d "$FOLDER/$SAVEFOLDER/$current_version" ];
then
	cp $FOLDER/$SAVEFOLDER/config.yml.old $FOLDER/config.yml
	cp $FOLDER/$SAVEFOLDER/TeaData.sqlite.old $FOLDER/TeaData.sqlite
	mv $FOLDER/config.yml.old $FOLDER/$SAVEFOLDER/$current_version
	mv $FOLDER/TeaData.sqlite.old $FOLDER/$SAVEFOLDER/$current_version
	echo "# Backup succesfull! Backup folder: $FOLDER/$SAVEFOLDER/$current_version"
else
	echo "# Backup unsuccesfull! Backup folder ($FOLDER/$SAVEFOLDER/$current_version) not exist!"
fi
#Backup section - end

#Extracting update section - start
echo "##### Extracting it to $FOLDER/ #####";
tar -C $FOLDER/ -xzf /tmp/TeaSpeak.tar.gz --overwrite
echo "# Ready";
#Extracting update section - end

#Remove temp file section - start
echo "# Removing temporary file";
rm /tmp/TeaSpeak.tar.gz
echo "# Ready";
#Remove temp file section - end

#Make scripts executable section - start
echo "##### Making scripts executable #####"
chmod u+x $FOLDER/*.sh
echo "# Ready";
#Make scripts executable section - end

#Restart TeaSpeak server section - start
if [[ ! -z $START ]]
then
  echo "##### Restart TeaSpeak szerver ##### ";
  $FOLDER/$START;
fi
#Restart TeaSpeak server section - end
exit 0;