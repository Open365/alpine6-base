#!/bin/sh

InstallationDir="${InstallationDir:-/var/service}"

usage() {
    echo "$0 [--develop|--production] [-i|--install] [-p|--purgue]"
    echo " --develop, --production: type of script to use in the install or purgue, environment develop or production"
    echo " -i, --install:           install packages"
    echo " -p, --purgue:            purgue packages"
}

chargeListDependencies() {
    local is_develop=$1

    source /scripts-base/dependencies.list
    source "$InstallationDir"/alpine-dependencies-extra.list
    if [ $is_develop == true ]; then
        source "$InstallationDir"/alpine-dependencies-dev.list
    fi
}

executeInstall() {
    local is_install=$1

    if [ $is_install == true ]; then
        if [ -n "$add" ]; then
            /scripts-base/installExtraBuild.sh $add $add_dev
        fi
    fi
}

executePurgue() {
    local is_purgue=$1

    if [ $is_purgue == true ]; then
        if [ -n "$del" ]; then
            /scripts-base/deleteExtraBuild.sh $del $del_dev
        fi
    fi
}

if [ "$#" -eq 0 ]
then
    usage
    exit
fi

develop=false
purgue=false

for i in "$@"
do
    case $i in
        --develop)
        develop=true
        shift
        ;;
        --production)
        # --production kept for backward-compatibility reasons. It is really not needed anymore.
        develop=false
        shift
        ;;
        -i|--install)
        install=true
        purgue=false
        shift
        ;;
        -p|--purgue)
        install=false
        purgue=true
        shift
        ;;
    esac
done

chargeListDependencies $develop
executeInstall $install
executePurgue $purgue
