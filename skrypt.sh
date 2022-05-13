# Author : Paweł Mańczak (s188756@student.pg.edu.pl)
# Created on : 27.04.2022
# Last Modified By : Paweł Mańczak (s188756@student.pg.edu.pl)
# Last Modifien On : 28.04.2022

while getopts "chv " option; do
case ${option} in
h ) 
echo "Program oparty o graficzny interjes, słuzy do konwertowania plikow wideo na format mp33"
;;
v )
echo "werscja 1.0.0"
;;
* ) #For invalid option

   getFileNameWithoutExtension ()
    {
        filename=$(basename -- "$1");
        echo "$filename"| sed 's/\.[^.]*$//';
    }

    convToMp3 ()
    {
            FILENAME=$(getFileNameWithoutExtension "$1");
            echo "$FILENAME";
            if [ -f "$FILENAME.mp3" ]
            then
                eval "echo istnieje juz plik o takiej nazwie| \zenity --text-info --title \"blad\" --width 400"
            else
               if [[ ! -d "$KATALOG" ]]
               then 
                    $KATALOG = "";
               fi

                ffmpeg -i "./$1" -f mp3 -ab 192000 -vn "$FILENAME.mp3";
                eval "echo skonwerowano pomyslnie| \zenity --text-info --title \"Skonwertowano\" --width 400 --height 200"

            fi
    }


REQUIRED_PKG="ffmpeg"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG 
fi


command=-1
NAZWA="wprowadz nazwe"
while [ "$command" != 8 ]; do

c1="1. Nazwa pliku: $NAZWA"
c2="2. Scieszka do zapisu: $KATALOG"
c3="3. Konwertuj"
c4="4. Wyjdz"

MENU=("$c1" "$c2" "$c3" "$c4")
	command=$(zenity --list --column=MENU "${MENU[@]}" --height 500)

case "$command" in

	$c1)NAZWA=$(zenity --entry --title "Nazwa" --text "Wpisz nazwę ")
	    if [ -z $NAZWA ]; then
	        NAZWA="nazwa_domyslna"
		fi;;
	$c2)KATALOG=$(zenity --entry --title "KATALOG" --text "Wpisz nazwę katalogu ");;
    $c3)
        if [ -f $NAZWA ] && [ ! -z $NAZWA ]
        then
            convToMp3 "$NAZWA"
        else
           eval "echo nie ma takiego pliku| \zenity --text-info --title \"blad\" --width 400 --height 200"
        fi;;

	$c4)command=8;;
esac

done
;;
esac
done