#!/bin/sh

goPath=$(which go > /dev/null 2>&1)
if [ "$?" -ne 0 ]; then
   echo "[INFO] Go is not in the path... adding!"
   newPath="export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin"
   echo "${newPath}" >> ~/.bashrc
   echo "${newPath}" >> ~/.profile
else
   echo "[INFO] Go is in the path already!"
fi
