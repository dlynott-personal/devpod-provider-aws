#!/bin/sh

goPath=$(which go > /dev/null 2>&1)
if [ $? -ne 0 ]; then
   # Add go to the path
   newPath="export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin"
   echo "${newPath}" >> ~/.bashrc
   echo "${newPath}" >> ~/.profile
fi
