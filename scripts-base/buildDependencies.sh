#!/bin/sh

usage() {
    echo "$0 [--develop|--production] [-i|--install] [-p|--purgue] -s=<name_microservice>"
    echo " --develop, --production: type of script to use in the install or purgue, environment develop or production"
    echo " -i, --install:           install packages"
    echo " -p, --purgue:            purgue packages"
    echo " -s, --service:           microservice's name"
}

chargeProductionListDependencies() {
    if [ $1 == true ]; then
        source /scripts-base/dependencies-extra.list
    fi
}

chargeDevelopListDependencies() {
    if [ $1 == true ]; then
        source /scripts-base/dependencies-dev.list
    fi
}

setNameMicroService() {
    if [ $1 == false ]; then
        nameservice=$WHATAMI
    fi
}

executeInstall() {
    if [ $2 == true ]; then
        service="add$1"
        eval dependencies=\$$service
        if [ ${#dependencies} -gt 0 ]; then
            if [ $3 == true ]; then
                /scripts-base/installExtraBuild.sh $dependencies
            fi
            if [ $4 == true ]; then
                /scripts-base/installDevBuild.sh $dependencies
            fi
        else
            echo "Error dependencies doesn't available"
        fi
    fi
}

executePurgue() {
    if [ $2 == true ]; then
        service="del$1"
        eval dependencies=\$$service
        if [ ${#dependencies} -gt 0 ]; then
            if [ $3 == true ]; then
                /scripts-base/deleteExtraBuild.sh $dependencies
            fi
            if [ $4 == true ]; then
                /scripts-base/deleteDevBuild.sh $dependencies
            fi
        else
            echo "Error dependencies doesn't available"
        fi
    fi
}

if [ "$#" -eq 0 ]
then
    usage
    exit
fi

develop=false
production=false
purgue=false
service=false
nameservice=""

for i in "$@"
do
    case $i in
        --develop)
        develop=true
        production=false
        shift
        ;;
        --production)
        develop=false
        production=true
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
        -s=*|--service=*)
        service=true
        nameservice="${i#*=}"
        shift
        ;;
    esac
done

chargeProductionListDependencies $production
chargeDevelopListDependencies $develop
setNameMicroService $service

service="${nameservice//-}"

executeInstall $service $install $production $develop
executePurgue $service $purgue $production $develop