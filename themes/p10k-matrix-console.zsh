# Powerlevel10k — Matrix Console
# Three-level green/teal terminal dashboard with no line connectors.

typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
'builtin' 'local' '-a' p10k_config_opts
[[ ! -o aliases ]] || p10k_config_opts+=(aliases)
[[ ! -o sh_glob ]] || p10k_config_opts+=(sh_glob)
[[ ! -o no_brace_expand ]] || p10k_config_opts+=(no_brace_expand)
'builtin' 'setopt' no_aliases no_sh_glob brace_expand

() {
  emulate -L zsh -o extended_glob
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return
  typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

  # Soft Matrix palette.
  typeset -g P10K_MATRIX_DIM='#50645F' P10K_MATRIX_TEXT='#D8F3E8'
  typeset -g P10K_MATRIX_GREEN='#69F0AE' P10K_MATRIX_TEAL='#64FFDA'
  typeset -g P10K_MATRIX_CYAN='#80CBC4' P10K_MATRIX_LIME='#B9F27C'
  typeset -g P10K_MATRIX_YELLOW='#FFD166' P10K_MATRIX_RED='#FF6B6B'

  # Line 1: system, line 2: project, line 3: command input.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon context cpu_arch
    newline
    dir vcs package node_version pyenv virtualenv rust_version go_version java_version
    docker_context kubecontext terraform aws
    newline prompt_char
  )
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    ram load battery time
    newline
    status command_execution_time background_jobs disk_usage
    newline
  )

  # Transparent layout separated by whitespace only.
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR='  '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=' '

  # Built-in OS icon, with an Arch fallback for CachyOS/unknown Arch derivatives.
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$P10K_MATRIX_GREEN
  if [[ -r /etc/os-release ]]; then
    local release=(${(f)"$(</etc/os-release)"})
    local ids=(${(@M)release:#ID=*}) likes=(${(@M)release:#ID_LIKE=*}) id like
    (( $#ids == 1 )) && id=${(Q)${ids[1]#ID=}}
    (( $#likes == 1 )) && like=${(Q)${likes[1]#ID_LIKE=}}
    case $id in
      arch|manjaro|artix|endeavouros) ;;
      cachyos) typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='' ;;
      *) [[ " $like " == *' arch '* ]] && typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='' ;;
    esac
  fi

  # Remote/root identity and CPU architecture.
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=$P10K_MATRIX_RED
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=$P10K_MATRIX_CYAN
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
  typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='󰀄'
  typeset -g POWERLEVEL9K_CPU_ARCH_FOREGROUND=$P10K_MATRIX_DIM
  typeset -g POWERLEVEL9K_CPU_ARCH_VISUAL_IDENTIFIER_EXPANSION=''

  # Directory styling.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$P10K_MATRIX_TEAL
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$P10K_MATRIX_DIM
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$P10K_MATRIX_TEXT
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='󰉋'
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…'
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=65
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false

  # Compact detailed Git formatter.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
  function p10k_matrix_git_formatter() {
    emulate -L zsh
    if [[ -n $P9K_CONTENT ]]; then typeset -g P10K_MATRIX_GIT=$P9K_CONTENT; return; fi
    local meta="%F{$P10K_MATRIX_CYAN}" ok="%F{$P10K_MATRIX_GREEN}"
    local warn="%F{$P10K_MATRIX_YELLOW}" bad="%F{$P10K_MATRIX_RED}" r branch
    if (( ! $1 )); then meta="%F{$P10K_MATRIX_DIM}"; ok=$meta; warn=$meta; bad=$meta; fi
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      branch=${(V)VCS_STATUS_LOCAL_BRANCH}; (( $#branch > 30 )) && branch[12,-12]='…'
      r+="${meta}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    elif [[ -n $VCS_STATUS_TAG ]]; then r+="${meta} ${(V)VCS_STATUS_TAG//\%/%%}"
    else r+="${meta} ${VCS_STATUS_COMMIT[1,8]}"; fi
    (( VCS_STATUS_COMMITS_BEHIND )) && r+=" ${meta}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD )) && r+=" ${meta}⇡${VCS_STATUS_COMMITS_AHEAD}"
    (( VCS_STATUS_STASHES )) && r+=" ${warn}≡${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION ]] && r+=" ${bad}⚠${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && r+=" ${bad}✘${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED )) && r+=" ${warn}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED )) && r+=" ${warn}~${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED )) && r+=" ${warn}?${VCS_STATUS_NUM_UNTRACKED}"
    if (( ! VCS_STATUS_STASHES && ! VCS_STATUS_NUM_CONFLICTED && ! VCS_STATUS_NUM_STAGED &&
          ! VCS_STATUS_NUM_UNSTAGED && ! VCS_STATUS_NUM_UNTRACKED )) && [[ -z $VCS_STATUS_ACTION ]]; then
      r+=" ${ok}✓"
    fi
    typeset -g P10K_MATRIX_GIT=$r
  }
  functions -M p10k_matrix_git_formatter 2>/dev/null
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((p10k_matrix_git_formatter(1)))+${P10K_MATRIX_GIT}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((p10k_matrix_git_formatter(0)))+${P10K_MATRIX_GIT}}'
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND,STASHES}_MAX_NUM=-1

  # Project, runtime, container, orchestration and cloud icons.
  typeset -g POWERLEVEL9K_PACKAGE_FOREGROUND=$P10K_MATRIX_TEXT
  typeset -g POWERLEVEL9K_PACKAGE_VISUAL_IDENTIFIER_EXPANSION='󰏗'
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=$P10K_MATRIX_LIME
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND=$P10K_MATRIX_CYAN
  typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local)
  typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=false
  typeset -g POWERLEVEL9K_PYENV_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$P10K_MATRIX_CYAN
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=if-different
  typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=$P10K_MATRIX_YELLOW
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$P10K_MATRIX_TEAL
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=$P10K_MATRIX_LIME
  typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_JAVA_VERSION_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=$P10K_MATRIX_CYAN
  typeset -g POWERLEVEL9K_KUBECONTEXT_VISUAL_IDENTIFIER_EXPANSION='󱃾'
  typeset -g POWERLEVEL9K_TERRAFORM_FOREGROUND=$P10K_MATRIX_TEAL
  typeset -g POWERLEVEL9K_TERRAFORM_VISUAL_IDENTIFIER_EXPANSION='󱁢'
  typeset -g POWERLEVEL9K_AWS_FOREGROUND=$P10K_MATRIX_YELLOW
  typeset -g POWERLEVEL9K_AWS_VISUAL_IDENTIFIER_EXPANSION=''

  # Docker context with a five-second cache.
  typeset -g P10K_MATRIX_DOCKER_CACHE=
  typeset -gi P10K_MATRIX_DOCKER_AT=-10
  function prompt_docker_context() {
    emulate -L zsh
    (( $+commands[docker] )) || return
    local ctx=$DOCKER_CONTEXT
    if [[ -z $ctx ]]; then
      if (( SECONDS - P10K_MATRIX_DOCKER_AT >= 5 )); then
        P10K_MATRIX_DOCKER_CACHE=$(command docker context show 2>/dev/null)
        P10K_MATRIX_DOCKER_AT=$SECONDS
      fi
      ctx=$P10K_MATRIX_DOCKER_CACHE
    fi
    [[ -n $ctx ]] && p10k segment -f $P10K_MATRIX_CYAN -i '' -t "${ctx//\%/%%}"
  }

  # System monitor on the first right-prompt line.
  typeset -g POWERLEVEL9K_RAM_FOREGROUND=$P10K_MATRIX_CYAN
  typeset -g POWERLEVEL9K_RAM_VISUAL_IDENTIFIER_EXPANSION='󰍛'
  typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=$P10K_MATRIX_GREEN
  typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=$P10K_MATRIX_YELLOW
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=$P10K_MATRIX_RED
  typeset -g POWERLEVEL9K_LOAD_VISUAL_IDENTIFIER_EXPANSION='󰓅'
  typeset -g POWERLEVEL9K_BATTERY_FOREGROUND=$P10K_MATRIX_GREEN
  typeset -g POWERLEVEL9K_BATTERY_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$P10K_MATRIX_TEXT
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%a %H:%M}'
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=''

  # Command input and project status on the second right-prompt line.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$P10K_MATRIX_GREEN
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$P10K_MATRIX_RED
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_{SIGNAL,PIPE}=true
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_FOREGROUND=$P10K_MATRIX_RED
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$P10K_MATRIX_YELLOW
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='󱎫'
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$P10K_MATRIX_TEAL
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='󰜎'
  typeset -g POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=true
  typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=85
  typeset -g POWERLEVEL9K_DISK_USAGE_FOREGROUND=$P10K_MATRIX_YELLOW
  typeset -g POWERLEVEL9K_DISK_USAGE_VISUAL_IDENTIFIER_EXPANSION='󰋊'

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' p10k_config_opts

