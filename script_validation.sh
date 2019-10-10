#!/bin/sh

echo -e "\e[91m Bienvenue sur le script de validation !\e[0m "

check=$(dpkg -s vagrant | wc -l)
if [ $check -eq 12 ]
then echo -e "\e[91m Le package de vagrant est déjà installé \e[0m"
else apt install vagrant
fi
check=$(dpkg -s virtualbox | wc -l)
if [ $check -eq 26 ]
then echo -e "\e[91mLe package de virtual box est déjà installé \e[0m"
else apt install virtualbox
fi

vagrant init

echo "Vagrant.configure("\"2"\") do |config|" > Vagrantfile

# Personnalisation du nom de la box
echo "Merci de choisir parmis ces trois boxes :
     1) ubuntu/trusty64
     2) ubuntu/xenial64
     3) scotch/box
    "
read boxChoice
case $boxChoice in
    1)
        echo -e "\e[91mBox trusty choisie.\e[0m"
        echo "config.vm.box = \"ubuntu/trusty64\"" >> Vagrantfile
    ;;
    2)
        echo -e "\e[91mBox xenial choisie.\e[0m"
        echo "config.vm.box = \"ubuntu/xenial64\"" >> Vagrantfile
    ;;
    3)
        echo -e "\e[91mBox scotch choisie.\e[0m"
        echo "config.vm.box = \"scotch/box\"" >> Vagrantfile
        ;;
    *)
        echo -e "\e[91mBox par défaut (xenial) chosie.\e[0m"
        echo "config.vm.box = \"ubuntu/xenial64\"" >> Vagrantfile
    ;;
esac

# Personnalisation de l'adresse IP

echo -e "\e[91mAssignation par défaut de l'IP suivante : 192.168.33.10\e[0m"
read -p "Voulez-vous modifier l'adresse IP attribuée à l'environnement virtuel ? O/n" choice

if [ $choice == "O" ]
then
    echo -e "\e[91mLes deux derniers chiffres de l'IP seront modifiés.\e[0m"
    read -p " Merci d'entrer les deux derniers chiffres à modifier : " ipnumbers
    echo "config.vm.network \"private_network\", ip: \"192.168.33."$ipnumbers"\"" >> Vagrantfile
else
    echo -e "\e[91mTrès bien. L'adresse IP est inchangée\e[0m"
    echo "config.vm.network "\"private_network"\", ip: "\"192.168.33.10"\"" >> Vagrantfile
fi


# Personnalisation le nom du dossier synchronisé local
read -p "Voulez-vous modifier le nom du dossier synchronisé local ? O/n\e[0m" choice
read -p "Voulez-vous modifier le nom du dossier synchronisé distant ? O/n\e[0m" choice2

if [ "$choice" = "O" ] && [ "$choice2" = "O" ]
then
    read -p "Merci d'entrer le nouveau nom du dossier local : " folderName
    read -p "Merci d'entrer le nouveau nom du dossier distant : " folderName2
    mkdir $folderName
    echo "config.vm.synced_folder "\"./$folderName"\", "\"/$folderName2"\"" >> Vagrantfile
    echo -e "\e[91mTrès bien. Le nom du dossier par défaut sera donc $forlderName et celui du distant $folderName2\e[0m"

elif [ "$choice" = "O" ] && [ "$choice2" = "n" ]
then
    echo -e "\e[91mTrès bien. Le nom du dossier par défaut sera donc 'data'\e[0m"
    mkdir $forlderName
    echo "config.vm.synced_folder "\"./$folderName"\", "\"/vagrant_data"\"" >> Vagrantfile
    echo -e "\e[91mTrès bien. Le nom du dossier par défaut sera donc $folderName et celui du distant vagrant_data\e[0m"
elif [ "$choice" = "n" ] && [ "$choice2" = "O" ]
then
    echo -e "\e[91mTrès bien. Le nom du dossier par défaut sera donc data et celui du distant $folderName2\e[0m"
    mkdir data
    echo "config.vm.synced_folder "\"./data"\", "\"/$folderName2"\"" >> Vagrantfile
else
    echo -e "\e[91mTrès bien. Le nom du dossier local par défaut sera donc data et le distant vagrant_data\e[0m"
    mkdir data
    echo "config.vm.synced_folder "\"./data"\", "\"/vagrant_data"\"" >> Vagrantfile
fi


echo "end" >> Vagrantfile

echo -e "\e[91mt Affichage des vagrants en cours d'utilisation\e[0m"

vagrant global-status

# Lancement de la vagrant

read -p "Voulez-vous démarrer la vagrant ? O/n" choice

if [ choice == "O" ]
then
  vagrant up
else
  echo -e "\e[91mt Fin du programme \e[0m"
fi
