#!/bin/zsh

unzip sessionmanager-bundle.zip
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
./sessionmanager-bundle/install -h
session-manager-plugin
session-manager-plugin --version
