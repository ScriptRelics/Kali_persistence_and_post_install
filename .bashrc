# ~/.bashrc: executed by bash(1) for non-login shells.

FG_BLACK=$'\e[30m';
FG_RED=$'\e[31m';
FG_GREEN=$'\e[32m';
FG_YELLOW=$'\e[33m';
FG_BLUE=$'\e[34m';
FG_MAGENTA=$'\e[35m';
FG_CYAN=$'\e[36m';
FG_WHITE=$'\e[37m';
BG_BLACK=$'\e[40m';
BG_RED=$'\e[41m';
BG_GREEN=$'\e[42m';
BG_YELLOW=$'\e[43m';
BG_BLUE=$'\e[44m';
BG_MAGENTA=$'\e[45m';
BG_CYAN=$'\e[46m';
BG_WHITE=$'\e[47m';
FONT_RESET=$'\e[0m';
FONT_BOLD=$'\e[1m';
FONT_BRIGHT="$FONT_BOLD";
FONT_DIM=$'\e[2m';
FONT_UNDERLINE=$'\e[4m';
FONT_BLINK=$'\e[5m';
FONT_REVERSE=$'\e[7m';
FONT_HIDDEN=$'\e[8m';
FONT_INVISIBLE="$FONT_HIDDEN";


let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

# get the load averages
read one five fifteen rest < /proc/loadavg

echo "$(tput setaf 2)
   .~~.   .~~.    `date +"%A, %e %B %Y, %X %Z"`
  '. \ ' ' / .'   `uname -srmo`$(tput setaf 1)
   .~ .~~~..~.
  : .~.'~'.~. :   $FG_WHITE Uptime.............: ${UPTIME} $FG_RED
 ~ (   ) (   ) ~  $FG_WHITE Memory.............: `cat /proc/meminfo | grep MemFree | awk {'print $2'}`kB (Free) / `cat /proc/meminfo | grep MemTotal | awk {'print $2'}`kB (Total) $FG_RED
( : '~'.~.'~' : ) $FG_WHITE Load Averages......: ${one}, ${five}, ${fifteen} (1, 5, 15 min) $FG_RED
 ~ .~ (   ) ~. ~  $FG_WHITE Running Processes..: `ps ax | wc -l | tr -d " "` $FG_RED
  (  : '~' :  )   $FG_WHITE CPU Temperature....:$FG_RED
   '~ .~~~. ~'    $FG_WHITE Free Disk Space....: `df -Ph | grep -E '^/dev/root' | awk '{ print $4 " of " $2 }'` $FG_RED
       '~'        $FG_WHITE IP Addresses.......: `ifconfig | grep 'inet ' | grep -v '127.0.0.1' | awk '{ print $2 }'` $FONT_RESET

$(tput sgr0)"


alias ll='ls $LS_OPTIONS -lah'
alias la='ls $LS_OPTIONS -lah'
alias l='ls $LS_OPTIONS -Ap'

alias dir="dir --color=auto"
alias grep="grep --color=auto"
alias dmesg='dmesg --color'

alias ls='ls $LS_OPTIONS -Ap'               # Preferred ‘ls’ implementation
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up

# #(Number of jobs) if the last command was sucessful then display red name @ green highlight else display red name @ red highlight:(PATH)(NEW LINE)
PS1="\n#\j \[\`if [[ \$? = "0" ]]; then echo '$FONT_BOLD$FG_RED\u$FONT_RESET$FONT_BOLD@$BG_GREEN\h$FONT_RESET'; else echo '$FONT_BOLD$FG_RED\u$FONT_RESET@$FONT_BOLD$BG_RED\h$FONT_RESET' ; fi\`:\w\n"


