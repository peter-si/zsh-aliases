# Personal zsh aliases, loaded via zplug ("peter-si/zsh-aliases").
# Public repo: no host details here. Machine-specific values (DEV_SSH_HOST,
# DEV_VNC_TARGET) are exported by the private dotfiles.

# ls shortcuts. `command ls` pins GNU ls: these flags break if `ls` is aliased
# to eza (as on Omarchy, where zshrc also redefines la/ll/lt with eza).
alias l='command ls -lFh'     #size,show type,human readable
alias la='command ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='command ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='command ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='command ls -l'      #long list
alias ldot='command ls -ld .*'
alias lS='command ls -1FSsh'
alias lart='command ls -1Fcart'
alias lrt='command ls -1Fcrt'
alias cd..='cd ..'
alias cpr='cp -r'
alias rmrf='rm -rf'
alias ducks='du -cks * | sort -rn | head'
alias duh='du -hs * | sort -rh | head'
alias kc="kubecolor"
alias kx="kubectx"
alias kns="kubens"

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tmux attach || tmux new -s Work'

alias zshreload='source ~/.zshrc'
alias zshconf='${=EDITOR} ${ZDOTDIR:-$HOME}/.zshrc' # Quick access to the .zshrc file
alias sshconf='${=EDITOR} ~/.ssh/config'
alias nano='nano -clSg_/'
alias pax='ps aux'
alias ssh='TERM=xterm-256color ssh'
alias packages='comm -23 <(yay -Qqett | sort) <(yay -Qqg base -g base-devel | sort | uniq)'

# Remote dev box. DEV_SSH_HOST (an ~/.ssh/config Host) and DEV_VNC_TARGET
# (host:port) are exported per-machine, so no host details live in this repo.
# dev  — ssh into a persistent tmux session
# devv — the box's VNC desktop in Remmina (native-Wayland clipboard, works both ways)
alias dev='ssh -t "${DEV_SSH_HOST:?DEV_SSH_HOST not set}" tmux new -A -s main'
alias devv='remmina -c "vnc://${DEV_VNC_TARGET:?DEV_VNC_TARGET not set}" >/dev/null 2>&1 &!'

# Command line head / tail shortcuts
if [[ -n $WAYLAND_DISPLAY ]] && (( $+commands[wl-copy] )); then
  alias -g C='| wl-copy'
else
  alias -g C='| xclip -selection clipboard'
fi
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep -i'
alias -g L="| less"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fdir='find . -type d -name'
alias ffile='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'


# zsh is able to auto-do some kungfoo
# depends on the SUFFIX :)
autoload -Uz is-at-least
if is-at-least 4.2.0; then
  # open browser on urls
  if [[ -n "$BROWSER" ]]; then
    _browser_fts=(htm html de org net com at cx nl se dk)
    for ft in $_browser_fts; do alias -s $ft=$BROWSER; done
  fi

  _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
  for ft in $_editor_fts; do alias -s $ft=$EDITOR; done

  if [[ -n "$XIVIEWER" ]]; then
    _image_fts=(jpg jpeg png gif mng tiff tif xpm)
    for ft in $_image_fts; do alias -s $ft=$XIVIEWER; done
  fi

  # media + documents open in the desktop's default app
  if (( $+commands[xdg-open] )); then
    _open_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm wav webm pdf djvu)
    for ft in $_open_fts; do alias -s $ft=xdg-open; done
  fi

  #list whats inside packed file
  alias -s zip="unzip -l"
  alias -s rar="unrar l"
  alias -s tar="tar tf"
fi

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
