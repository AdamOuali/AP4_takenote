# AP4_takenote

Script to take note in term

## Man PAGE

### NAME

    takenote [ -t <noteTitles>| -c| -l <n> ] [ -a| -e| -s| -r ]

### DESCRIPTION

Takenote is a program that allow you to take notes quickly and easely.

### COMMANDS

The commande is splited in 2 parts:

- the selector argument
- the action argument

#### SELECTOR

DEFAULT
> Select the last modified note.

-t
> Select notes by approcimative title. If the arguments passed is contained in the notes list, select this note. If the arguments doesn't match any notes from the list it create a new note

-c
> Select the notes using the fzf command line tool. You can select multiple notes using the tab key.

-l \<n>
> Select the n last modified notes.

#### ACTION

DEFAULT
> Appened multiple line into selected notes. use the keyword "exit" to exit the code editor.

-a \<noteContent>
> Appened \<noteContent> to the selected notes. if \<noteContent> is empty act as default.

-e
> Edit the selected notes (using the command line tool: nano).

-s
> Display the choosen notes (using the command line tool: less).

-r
> Remove the choosen notes

#### GUI

You can use the takenote GUI by using takenote without argument.
It allow you to:

- Add a note

> Correspond to takenote.sh -y -t

- Display a note

> Correspond to takenote.sh -y -c -s

- Display last modified note

> Correspond to takenote.sh -y -s

- Display 3 last modified notes

> Correspond to takenote.sh -y -l 3 -s
