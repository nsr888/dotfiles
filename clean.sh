#!/bin/bash
brew update
brew upgrade
brew cleanup -s
df -h ~/
du -hd1 ~/ | sort -h
