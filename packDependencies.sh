#!/bin/bash

#####################################################
# script to pack dependencies from requirements.txt
#####################################################

echo "######################################## Pack dependencies"
# get current venv
CURRENT_VENV=$VIRTUAL_ENV

TARGET_PATH="target"

rm -r ./${TARGET_PATH}

mkdir ./${TARGET_PATH}

VENV_PATH="./${TARGET_PATH}/dependenciesVenv"

# create new venv
python3 -m venv ${VENV_PATH}
source ${VENV_PATH}/bin/activate

# install only requirements from requirements.txt
python3 -m pip install -r requirements.txt

# deactivate venv
deactivate

# pack dependencies
(cd ${VENV_PATH}/lib/python3.10/site-packages && zip -rq "$OLDPWD/${TARGET_PATH}/dependencies.zip" .)

# reactivate old venv
source ${CURRENT_VENV}/bin/activate
