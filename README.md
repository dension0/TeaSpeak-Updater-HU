 TeaSpeak-updatebackupscript
TeaSpeak update and backup script for Debian linux

TeaSpeak updater by Nicer (https://github.com/Najsr/TeaSpeak-Updater)
TeaSpeak Updater by essemX (github.com/essemX/teaspeak-updatescript)
NOT Tested YET

Usege:

download into based of TeaSpeak folder

Add command: chmod u+x updateandbackup.sh

Run ./updateandbackup.sh

-f / --force - forces update (without prompt) example: -f updateandbackup.sh

-p path / --path path Sets working path for the script (otherwise executed in the location of the script) example: -p updateshfoldername updateandbackup.sh

-s / --start Starts server after successful update via teastart.sh start (you may add name of script with parameters to change this value) example: -s updateandbackup.sh
