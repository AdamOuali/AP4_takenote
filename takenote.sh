#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
bannerPath="$SCRIPT_DIR/lib/asset/banner.txt"
noteDirPath="$SCRIPT_DIR/notes"

### functions
length(){ echo $#;}

getCustomLine(){
	read -p "~ " $1
}

multilineAppend (){
	printf "Content :\n(type \"exit\" to end your note)\n\n" content_to_add
	getCustomLine current_read_line
	content_to_add=""
	while [ -z "$current_read_line" ] || [ ! "$current_read_line" = "exit" ]
	do
		content_to_add="$content_to_add$current_read_line\n"
		getCustomLine current_read_line
	done
	printf "$content_to_add" >> "$1"
}

getNote (){
	ls -1t $noteDirPath
}

getNewNoteTitle (){
	read -p "Note Title : " note_title
	echo "$note_title" | tr '/[\\/:*?\"\ <> |]/g' '_'
}

newNote (){
	note_title="$(getNewNoteTitle)"
	$SCRIPT_DIR/takenote.sh -y -t "$note_title"
}

addPrefixe (){
	echo "$(date +%d-%m-%Y_H%H).txt"
}

getNLastNotes (){
	lastNotes=$(getNote | head -$1)
	if [ -z "$lastNotes" ];then
		echo "$(getNewNoteTitle)""_[new]"
	fi
	echo $lastNotes
}

### MAIN PROG

### dependencies checking
$SCRIPT_DIR/depCheck.sh

### check if directory exists / create it if directory does not exist
if [ ! -d $noteDirPath ];then
	mkdir $noteDirPath
	printf "Le répertoire de stockage n'existe pas. Création du répertoire effectué."
fi

function guiFunc(){
	### banner display
	if [ -f $bannerPath ];then
		cat $bannerPath
	fi

	### menu display
	choice=$(printf "# 1 . Ajouter une note\n# 2 . Consulter une note\n# 3 . Consulter la dernière entrée\n# 4 . Consulter les 3 dernières notes" | fzf --tac --cycle --no-info --height 5 | awk '{print $2}')
	

	### choices
	case $choice in
		1 )
		newNote
		;;
		2 )
		$SCRIPT_DIR/takenote.sh -y -c -s
		;;
		3 )
		$SCRIPT_DIR/takenote.sh -y -s
		;;
		4 )
		$SCRIPT_DIR/takenote.sh -y -l 3 -s
		;;
	esac
}

SELECT_COMMAND=""
ACTION_COMMAND=""
INTERACTIVE_COMMAND=""
SELECT_ARG=()
ACTION_ARG=()
last_option_type_read=""
## If no arg launch GUI
if [ $# -eq "0" ]; then
	guiFunc
	exit 0
fi

### Manage Option
for arg in "$@"; do
	case $arg in
		-t | -c | -l )
			if [ ! -z $SELECT_COMMAND ]; then
				printf "Error: to many SELECT argument\n"
				exit 1
			fi
			SELECT_COMMAND=$arg
			last_option_type_read="S"
			;;
		-e | -a | -r | -s)
			if [ ! -z $ACTION_COMMAND ]; then
				printf "Error: to many ACTION argument\n"
				exit 1
			fi
			ACTION_COMMAND=$arg
			last_option_type_read=""
			;;
		-y)
			INTERACTIVE_COMMAND="1"
		;;
		*)
			if [ -z $last_option_type_read ]; then
				ACTION_ARG+=("$arg")
			else
				SELECT_ARG+=("$(echo $arg | tr '/[\\/:*?\"\ <> |]/g' _)")
			fi
			;;
	esac
done

case $SELECT_COMMAND in
	-c )
		SELECT_ARG=$(getNote | fzf -m --height 10)
		INTERACTIVE_COMMAND="1"
	;;
	-t )
		tmpList=()
		for selectArgs in ${SELECT_ARG[@]}; do
			tmpNoteTitle=$(getNote | grep $selectArgs )
			if [ ! -z "$tmpNoteTitle" ];then
				tmpList+=( "$tmpNoteTitle" )
			else
				tmpList+=( "$selectArgs""_[new]" )
			fi
		done
		SELECT_ARG=( ${tmpList[@]} )
	;;
	-l )
		if [ -n "$SELECT_ARG" ] && [ "$SELECT_ARG" -eq "$SELECT_ARG" ]; then
			SELECT_ARG=( $(getNLastNotes $SELECT_ARG) )
		else
			printf "Error: Missing argument for option -l (Number of Notes)\n"
			exit 1
		fi
	;;
	*)
		SELECT_ARG=( "$(getNLastNotes 1)" )
	;;
esac
### Check if take have been selected

if [ ${#SELECT_ARG[@]} -lt 1 ]; then
	printf "Error: please select at least 1 valid note title\n"
	exit 1
fi
if [ -z $INTERACTIVE_COMMAND ]; then
	echo "==============================="
	for t in ${SELECT_ARG[@]}; do
		printf "$t\n"
	done
	read -p "good notes ?[Y/n] :" choice
	if !([ -z $choice ] || ! ( [ $choice = "n" ] || [ $choice = "N" ] ));then
		exit 1
	fi
	echo "==============================="
fi
SELECT_ARG=(${SELECT_ARG[@]//"[new]"/"$(addPrefixe)"})
for t in ${SELECT_ARG[@]}; do
	touch "$noteDirPath/$t"
	case $ACTION_COMMAND in
		-e )
			nano -R "$noteDirPath/$t"
		;;
		-s )
			less "$noteDirPath/$t"
		;;
		-r )
			rm -f "$noteDirPath/$t"
			printf "$t Note Deleted\n"
		;;
		*)
			if [ ! -z $ACTION_ARG ]; then
				echo $ACTION_ARG >> "$noteDirPath/$t"
			else
				multilineAppend "$noteDirPath/$t"
			fi
		;;
	esac
done
