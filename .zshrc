if [ -z ${TMUX} ] && [ -z ${SSH_TTY} ]; then; tmux -t tmux || tmux new -s tmux; fi

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/mocha.omp.json)"
fi

autoload -Uz compinit && compinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit load zsh-users/zsh-autosuggestions
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

zinit load zdharma-continuum/fast-syntax-highlighting

zinit load marlonrichert/zsh-autocomplete
zstyle ':autocomplete:*' delay 2.0

zinit load MichaelAquilina/zsh-you-should-use
zinit load arzzen/calc.plugin.zsh
zinit load atuinsh/atuin

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
# bindkey '^[[1~' beginning-of-line
# bindkey '^[[4~' end-of-line
# bindkey '^[[3~' delete-char

if brew --version > /dev/null 2>&1; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.

eval "$(zoxide init zsh)"

export PATH="$HOME/.cargo/bin:$PATH"

neofetch

alias -- cd=z
alias -- k=kubectl
alias -- ll='eza -alh'
alias -- ls=eza
alias -- tree='eza --tree'
alias -- x='cargo xtask'
alias -- zz='z -'