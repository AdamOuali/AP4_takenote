#!/bin/sh

### banner display
cat /Users/adam/Desktop/testScript/banner.txt

### check if directory exists / create it if directory does not exist
if [ ! -d "notes" ]
then
	mkdir notes
	echo "Le répertoire de stockage n'existe pas. Création du répertoire effectué."
fi

### menu display
echo '# 1. Ajouter une note\n# 2. Consulter une note\n# 3. Consulter la dernière entrée\n# 4. Consulter les 3 dernières notes\n\n---------------------------------------\n\nChoix :'
read choice

### functions
setNewNote ( ){
	FILENAME=$(date +%d-%m-%Y_%H:%M:%S)
	FULLPATH="notes/$FILENAME.txt" 
	read -p "Contenu de la note : " content_to_add #read and add content to var content_to_add
	touch $FULLPATH
	echo $content_to_add > $FULLPATH
}

getNote ( ){
	find ./notes | fzf | xargs cat
}

getLastNote ( ){
	LASTFILENAME=$(ls -l notes | tail -n1 | awk '{print $9}')
	cat notes/$LASTFILENAME
}

getThreeLastNotes ( ){
	LASTFILENAME1=$(ls -l notes | tail -n3 | awk '{print $9}' | head -n1)
	LASTFILENAME2=$(ls -l notes | tail -n3 | awk '{print $9}' | tail -n2 | head -n1)
	LASTFILENAME3=$(ls -l notes | tail -n3 | awk '{print $9}' | tail -n1)

	echo "\n####### 3 DERNIERES NOTES #######\n"

	echo "--- Antépénultième :\n"
	cat notes/$LASTFILENAME1	
	echo "\n"
	
	echo "--- Pénultième :\n"
	cat notes/$LASTFILENAME2
	echo "\n"
	
	echo "--- Dernière :\n"
	cat notes/$LASTFILENAME3
	echo "\n"
}

### end functions

### choices
if [ $choice == "1" ]; then
	setNewNote


elif [ $choice == "2" ]; then 
	getNote

elif [ $choice == "3" ]; then  
	getLastNote

elif [ $choice == "4" ]; then 
	getThreeLastNotes

else
	sh /Users/adam/Desktop/testScript/takenote.sh
fi
