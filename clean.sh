#!/bin/bash
brew update
brew upgrade
brew cleanup -s
rm -rf ~/Library/Caches/
rm -rf ~/Library/Application\ Support/Slack/Service\ Worker/CacheStorage/
rm -rf ~/Library/Application\ Support/Slack/Cache/
rm -rf ~/Library/Application\ Support/Slack/Code\ Cache/
df -h ~/
du -hd1 ~/ | sort -h
