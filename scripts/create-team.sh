#!/bin/bash

read -p "Team name: " TEAM
read -p "Pipeline suffix: " SUFFIX
read -p "Parent image: " IMAGE

# check input variables are valid

# check parent image against list of valid modernisation platform images
mp_images='''
  mp-amazonlinux2
  mp-windowsserver2022
'''

if [[ $mp_images =~ $IMAGE ]] then
  :
else
  echo "Invalid parent image provided"
fi


# set default components to be used
if [[ $IMAGE == *"linux"* ]]; then
  OS="linux"
  COMPONENT="linux.yml"
  AWS_COMPONENT="yum-repository-test-linux"
elif [[ $IMAGE == *"windows"* ]]; then
  OS="windows"
  COMPONENT="windows.yml"
  AWS_COMPONENT="chocolatey"
fi


cp -r ./templates ../teams/${TEAM}


# find / replace all files with script inputs
(
  cd ../teams/${TEAM}

  for file in $(find . -maxdepth 1 -type f); do
      sed -i '' -e "s/#TEAM#/$TEAM/g" $file;
      sed -i '' -e "s/#SUFFIX#/$SUFFIX/g" $file;
      sed -i '' -e "s/#IMAGE#/$IMAGE/g" $file;
      sed -i '' -e "s/#OS#/$OS/g" $file;
      sed -i '' -e "s/#COMPONENT#/$COMPONENT/g" $file;
      sed -i '' -e "s/#AWS_COMPONENT#/$AWS_COMPONENT/g" $file;
  done
)


# create workflow
cp ./template.yml ../.github/workflows/${TEAM}_${SUFFIX}.yml

sed -i '' -e "s/#TEAM#/$TEAM/g" ../.github/workflows/${TEAM}_${SUFFIX}.yml
sed -i '' -e "s/#SUFFIX#/$SUFFIX/g" ../.github/workflows/${TEAM}_${SUFFIX}.yml
