brew update
brew upgrade
brew cleanup -s
echo '----------------------'
echo 'Size    Used    Avail'
echo '----------------------'
if [ "$HOSTNAME" = "aimac.local" ]; then
    df -h | grep disk2s5 | awk '{print $2 " = " $3 " + "  $4}'
else
    df -h | grep Users | awk '{print $2 " = " $3 " + "  $4}'
fi
#df -h | awk 'NR == 8{print $2 " = " $3 " + "  $4}'
rm -rf ~/Library/Application\ Support/Slack/Code\ Cache/
rm -rf ~/Library/Application\ Support/Slack/Cache/
rm -rf ~/Library/Application\ Support/Slack/Service\ Worker/CacheStorage/
rm -rf ~/Library/42_cache/
rm -rf ~/Library/Caches/*
rm -rf ~/.Trash/*
rm -rf ~/Library/Safari/*
rm -rf ~/.kube/cache/*
rm -rf ~/Library/Application\ Support/Code/CachedData/*
rm -rf ~/Library/Application\ Support/Code/User/workspaceStoratge
rm -rf ~/Library/Containers/com.docker.docker/Data/vms/*
rm -rf ~/Library/Containers/com.apple.Safari/Data/Library/Caches/*
rm -rf ~/Library/Application\ Support/Firefox/Profiles/0easr3zh.default-release/storage
if [ "$HOSTNAME" = "aimac.local" ]; then
    df -h | grep disk2s5 | awk '{print $2 " = " $3 " + "  $4}'
else
    df -h | grep Users | awk '{print $2 " = " $3 " + "  $4}'
fi
#df -h | awk 'NR == 8{print $2 " = " $3 " + "  $4}'
echo '----------------------'
du -hd1 ~/ | sort -h
