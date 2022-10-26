#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

dependenciesPath="$SCRIPT_DIR/lib/config/dependencies.txt"

### check dependencies
if [ ! -f $dependenciesPath ]
then
	touch $dependenciesPath
	printf "dependencies File created"
fi
for dependencies in $(cat $dependenciesPath)
do
	if ! dpkg -l $dependencies > /dev/null
	then
		read -p "install $dependencies ?[Y/n]" choice
		if [ -z $choice ] || ! ( [ $choice = "n" ] || [ $choice = "N" ] )
		then
			sudo apt install $dependencies
		else
			printf "Unable to install dependencie $dependencies"
			exit 0;
		fi
	fi
done