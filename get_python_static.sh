#!/bin/sh

# Grab everything after the '=' character
DOWNLOAD_URL=$(grep -i STATIC_PYTHON_SOURCE_URL .config | cut -f2 -d'=')

# Grab everything after the last '/' character
ARCHIVE_FILE=${DOWNLOAD_URL##*/}

cd source

# Downloading static python binary
# -c option allows the download to resume
wget -c $DOWNLOAD_URL

# Delete folder with previously extracted static python
rm -rf ../work/python
mkdir ../work/python

# Copy static python to folder 'python'
cp python* ../work/python

cd ..