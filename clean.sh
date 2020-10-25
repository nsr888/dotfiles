#!/bin/bash
brew update
brew upgrade
brew cleanup -s
df -h /Users/ksinistr
du -hd1 /Users/ksinistr/ | sort -h
