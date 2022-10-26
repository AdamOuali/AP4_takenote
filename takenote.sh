#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
bannerPath="$SCRIPT_DIR/lib/asset/banner.txt"
noteDirPath="$SCRIPT_DIR/notes"

### functions
getCustomLine(){
	read -p "~ " $1
}

setNewNote (){
	# get Note Title 
	read -p "Note Title : " note_title
	note_title="$(echo $note_title | tr '/ [\\/:*?\"<>|]/g' _)"
	note_title=$note_title"_$(date +%d-%m-%Y_H%H)"
	FULLPATH="$noteDirPath/$note_title.txt"
	printf "Content :\n(type \"exit\" to end your note)\n\n" content_to_add
	getCustomLine current_read_line
	content_to_add=""
	while [ -z "$current_read_line" ] || [ ! "$current_read_line" = "exit" ]
	do
		content_to_add="$content_to_add$current_read_line\n"
		getCustomLine current_read_line
	done
	touch $FULLPATH
	printf "$content_to_add" >> $FULLPATH
}

getNote (){
	find $noteDirPath | fzf | xargs cat
}

# TODO REFACTO
getLastNote (){
	LASTFILENAME=$(ls -l $noteDirPath | tail -n1 | awk '{print $9}')
	cat $noteDirPath/$LASTFILENAME
}

getThreeLastNotes (){
	LASTFILENAME1=$(ls -l $noteDirPath | tail -n3 | awk '{print $9}' | head -n1)
	LASTFILENAME2=$(ls -l $noteDirPath | tail -n3 | awk '{print $9}' | tail -n2 | head -n1)
	LASTFILENAME3=$(ls -l $noteDirPath | tail -n3 | awk '{print $9}' | tail -n1)

	printf "\n####### 3 DERNIERES NOTES #######\n"

	printf "--- Antépénultième :\n"
	cat $noteDirPath/$LASTFILENAME1	
	printf "\n"
	
	printf "--- Pénultième :\n"
	cat $noteDirPath/$LASTFILENAME2
	printf "\n"
	
	printf "--- Dernière :\n"
	cat $noteDirPath/$LASTFILENAME3
	printf "\n" 
}


### MAIN PROG

### dependencies checking
$SCRIPT_DIR/depCheck.sh

### check if directory exists / create it if directory does not exist
if [ ! -d $noteDirPath ];then
	mkdir $noteDirPath
	printf "Le répertoire de stockage n'existe pas. Création du répertoire effectué."
fi

SELECT_COMMAND=""
ACTION_COMMAND=""
SELECT_ARG=""
ACTION_ARG=""
last_option_type_read="SELECT"
### Manage Option
for arg in $@; do
	case $arg in
		-t | -c | -l )
			if [ -z $SELECT_COMMAND ]; then
				printf "Error: to many SELECT argument\n"
				exit 0
			fi
			SELECT_COMMAND=$arg
			last_option_type_read="S"
			;;
		-e | -a | -r | -s)
			if [ -z $ACTION_COMMAND ]; then
				printf "Error: to many ACTION argument\n"
				exit 0
			fi
			ACTION_COMMAND=$arg
			last_option_type_read=""
			;;
		*)
			if [ -z $last_option_type_read]; then
				ACTION_ARG="$ACTION_ARG$arg\n"
			else
				SELECT_ARG="$SELECT_ARG$arg\n"
			fi
			;;
	esac
done


case $SELECT_COMMAND in
	-t )
	;;
	-c )
	;;
	-l )
	;;
esac
		
### banner display
if [ -f $bannerPath ];then
	cat $bannerPath
fi

### menu display
printf "# 1. Ajouter une note
# 2. Consulter une note
# 3. Consulter la dernière entrée
# 4. Consulter les 3 dernières notes
\n---------------------------------------\n
"
read -p "Choix :" choice

### choices
if [ "$choice" = "1" ]; then
	setNewNote
elif [ "$choice" = "2" ]; then 
	getNote
elif [ "$choice" = "3" ]; then  
	getLastNote
elif [ "$choice" = "4" ]; then 
	getThreeLastNotes
else
	./takenote.sh
fi
