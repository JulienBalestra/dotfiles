# Environment


To get the current environment:


    uname -a

# Java Development Kit


In the Oracle web site, download the last stable JDK: 
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

You need a tar.gz like:

    stat jdk-8u60-linux-x64.tar.gz 
      File: 'jdk-8u60-linux-x64.tar.gz'
      Size: 181238643
      
Extract it:


    tar -xzvf jdk-8u60-linux-x64.tar.gz
    


Create the directory for the JDK:


    sudo mkdir -p /usr/local/lib/java
    sudo mv jdk1.8.0_60 /usr/local/lib/java
    

Create the JAVA_HOME and env variable:

    echo "export JAVA_HOME=/usr/local/lib/java/jdk1.8.0_60" >> ~/.profile
    echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.profile

Reload the env:


    . ~/.profile
    

# Intellij Idea

Download the last version: https://www.jetbrains.com/idea/download/

Extract the downloaded version


    tar -xzvf ideaIU-14.1.4.tar.gz
    
    
Create the appropriate directory for IDEs:


    sudo mkdir -p /usr/local/src/ide
    

Move the sources into the created directory;


    sudo mv idea-IU-141.1532.4 /usr/local/src/ide/
    
    
# Use

    /usr/local/src/ide/idea-IU-141.1532.4/bin/idea.sh
    
    
# Python 2.7 using

## Setup 
You need the following requirements:

    sudo apt-get update
    sudo apt-get install git python-pip python-virtualenv python-dev python-nose pylint
    
    
Under the Intellij Idea, install the plugin:


    File/Settings/Plugins/
        Install Jetbrains plugins... or Install plugin from Disk...
    Restart

## New project

    File/New/Project...
    Select Python
        Next