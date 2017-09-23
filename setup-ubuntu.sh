#!/bin/bash

set -ex 
set -o pipefail

test ${SUDO_USER}

## Chrome
apt-cache show google-chrome-stable || {
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
}
grep -c "http://dl.google.com/linux/chrome/deb/" /etc/apt/sources.list.d/google.list || {
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
}
## Chrome

## APT
apt-get update
apt-get upgrade -y

apt-get install -y vim git python3 strace curl python3-virtualenv make nmap jq python3-dev \
	google-chrome-stable
## apt

## Go
GOVERSION=1.8.3
mkdir -pv /usr/local/go
rm -Rf /usr/local/go/*
ls -l /usr/local/go/${GOVERSION} || {
	curl -fL https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz | tar -xzvf - --strip 1 -C /usr/local/go
}

grep -c "export GOROOT=/usr/local/go" /home/${SUDO_USER}/.profile || {
	echo "export GOROOT=/usr/local/go" >> /home/${SUDO_USER}/.profile
}

mkdir -pv /home/${SUDO_USER}/go/src/github.com/JulienBalestra
grep -c "export GOPATH=/home/${SUDO_USER}/go" /home/${SUDO_USER}/.profile || {
	echo "export GOPATH=/home/${SUDO_USER}/go" >> /home/${SUDO_USER}/.profile
}

chown ${SUDO_USER}: /home/${SUDO_USER}/.profile

set +e
su - ${SUDO_USER} -c 'go version' || {
	echo 'export PATH=${PATH}:${GOROOT}/bin/' >> /home/${SUDO_USER}/.profile
	chown ${SUDO_USER}: /home/${SUDO_USER}/.profile
}
set -e

mkdir -pv /home/${SUDO_USER}/go/src/github.com/JulienBalestra
chown -R ${SUDO_USER}: /home/${SUDO_USER}/go

su - ${SUDO_USER} -c 'go get -u github.com/tools/godep'
## Go


## Keyboard
grep -c 'setxkbmap -option "lv3:caps_switch"' /home/${SUDO_USER}/.bashrc || {
	echo 'setxkbmap -option "lv3:caps_switch"' >> /home/${SUDO_USER}/.bashrc
}
## Keyboard


## Alias
grep -c "alias gojb='cd /home/${SUDO_USER}/go/src/github.com/JulienBalestra'" /home/${SUDO_USER}/.bash_aliases || {
	echo "alias gojb='cd /home/${SUDO_USER}/go/src/github.com/JulienBalestra'" >> /home/${SUDO_USER}/.bash_aliases 
}

chown ${SUDO_USER}: /home/${SUDO_USER}/.bash_aliases
## Alias

## Git
git config --global user.email "julien.balestra@gmail.com"
git config --global user.name "JulienBalestra"
ls -l /home/${SUDO_USER}/ght
## Git

