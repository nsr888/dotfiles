#!/bin/bash
ls -la ~/Library/Caches
ls -la ~/Library/Application\ Support
ls -la ~/Library/Containers

# ~/.docker -> /goinfre/ksinistr/docker
# ~/Library/Containers/com.docker.docker -> /goinfre/ksinistr/agent

mkdir -p ~/goinfre/docker
mkdir -p ~/goinfre/agent

# mkdir -p ~/goinfre/.docker
# mkdir -p ~/goinfre/com.docker.helper

# ln -snf  /Users/ksinistr/goinfre/docker ~/.docker
# ln -snf  /Users/ksinistr/goinfre/agent ~/Library/Containers/com.docker.docker

# docker_home="$HOME/Library/Containers/com.docker.docker"
# docker_dest="$HOME/goinfre/com.docker.docker"
# 
# # move and symlink the docker home directory
# if ! { [[ -L $docker_home ]] && [[ -d $docker_home ]]; }; then
#     echo "Moving the docker folder to the local goinfre"
#     if [ ! -d $docker_dest ]; then
#         mkdir $docker_dest
#     fi
#     if [ -d $docker_home ]; then
#         mv $docker_home $docker_dest
#     fi
#     ln -sv $doker_dest $docker_home
# fi
