#!/bin/bash
# https://gist.github.com/eguven/23d8c9fc78856bd20f65f8bcf03e691b
brew list --formula | xargs -n1 -P8 -I {} \
    sh -c "brew info {} | egrep '[0-9]* files, ' | sed 's/^.*[0-9]* files, \(.*\)).*$/{} \1/'" | \
    sort -h -r -k2 - | column -t

echo 'List all package dependencies in Homebrew:'
echo '  brew deps --tree --installed'
echo '  brew deps --tree fontconfig'
echo '  brew deps --include-build --tree $(brew leaves)'
echo 'Remove a Homebrew package including all its dependencies'
echo '  brew rm FORMULA'
echo '  brew rm $(join <(brew leaves) <(brew deps FORMULA))'
