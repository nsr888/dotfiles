export ROOT_USER_NAME=username
alias gcc10="/usr/local/bin/gcc-10"
alias gcc10w="/usr/local/bin/gcc-10 -Wall -Wextra -Werror"
alias gcc10v="/usr/local/bin/gcc-10 -Wall -Wextra -Werror -ggdb3"
alias ccw="clang -Wall -Wextra -Werror"
alias ccv="clang -Wall -Wextra -Werror -ggdb3"
# alias norm="/Users/$ROOT_USER_NAME/opt/anaconda3/bin/norminette"
# alias norminette="/Users/$ROOT_USER_NAME/opt/anaconda3/bin/norminette"
alias ngit="git ls-files \*.{c,h} | xargs norminette"
alias valgrind="~/valgrind/bin/valgrind"
alias vg='~/valgrind/bin/valgrind --leak-check=full --show-leak-kinds=all -v --track-origins=yes --log-file=vg_logfile.out'
alias vim="/usr/bin/vim"
alias ovi="/usr/bin/vim"
alias vi="nvim"
alias ctags="`brew --prefix`/bin/ctags -R"
alias jtags="`brew --prefix`/bin/ctags -R && sed -i '' -E '/^(if|switch|function|module\.exports|it|describe).+language:js$/d' tags"
# alias ctags="`brew --prefix`/bin/ctags  -R --exclude=.git --exclude=log"
alias luamake='/Users/$ROOT_USER_NAME/dotfiles/lua-language-server/3rd/luamake/luamake'
# https://dev.to/joaovitor/exa-instead-of-ls-1onl
alias cat='bat --style=plain'
alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'

export PATH="/usr/local/sbin:$PATH"
export PATH="/Users/$ROOT_USER_NAME/clangd/bin:/Users/$ROOT_USER_NAME/clangd/lib:$PATH"
export PATH="/usr/local/Cellar/python@3.9/3.9.1/Frameworks/Python.framework/Versions/3.9/bin:$PATH"
export PATH="/Users/$ROOT_USER_NAME/Library/Python/3.9/bin/:$PATH"
export FZF_DEFAULT_COMMAND='ag -g ""'
export PATH="$PATH:/usr/local/go/bin"
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOBIN
export PATH=$PATH:$GOROOT/bin

# Load Git completion
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit

# CTRL+R enable history search with fzf, run:
# brew install fzf
# /usr/local/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k

export PATH="/Users/$ROOT_USER_NAME/dotfiles/bin:$PATH"
