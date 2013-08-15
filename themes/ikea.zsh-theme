
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
< on %{$fg[green]%}<branch|quiet>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[orange]%}>%{$reset_color%}>\
< at %{$fg[green]%}<bookmark>%{$reset_color%}>\
%{$fg[blue]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied()|post_unapplied()>>" 2>/dev/null
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function nodeenv_info {
    [ $NODE_VIRTUAL_ENV ] && echo '{'`basename $NODE_VIRTUAL_ENV`'} '
}

function wwdiff () {
  if [[ -f $1 && -f $2 ]]; then
    echo $1;
    echo $2;
    wdiff -n\
    -w $'\033[30;31m\033[4m' -x $'\033[0m'\
    -y $'\033[30;32m' -z $'\033[0m'\
    $1 $2 | less -R
  fi
}

PROMPT='
%{$fg[blue]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%} in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
$(virtualenv_info)$(nodeenv_info)$(prompt_char) '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
