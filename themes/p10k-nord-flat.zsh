# Powerlevel10k — Nord Icons, two-line prompt
#
# Simpan sebagai ~/.p10k.zsh, lalu muat dari ~/.zshrc dengan:
#   [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
#
# Tema ini memerlukan Nerd Font (v3+) agar semua ikon tampil dengan benar.
# Versi ini adalah redesign dari "Nord Flat": setiap segmen sekarang punya
# ikon visual identifier, lebih banyak informasi ditampilkan (RAM, baterai,
# Kubernetes, dsb.), dan palet Aurora Nord dipakai secara penuh
# supaya setiap jenis informasi punya warna khasnya sendiri.

typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

'builtin' 'local' '-a' p10k_config_opts
[[ ! -o aliases         ]] || p10k_config_opts+=(aliases)
[[ ! -o sh_glob         ]] || p10k_config_opts+=(sh_glob)
[[ ! -o no_brace_expand ]] || p10k_config_opts+=(no_brace_expand)
'builtin' 'setopt' no_aliases no_sh_glob brace_expand

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

  # ─────────────────────────── Palet Nord ───────────────────────────
  # Polar Night + Snow Storm untuk teks netral, Frost untuk identitas
  # (dir, git, tool version), dan seluruh Aurora untuk status/perhatian
  # supaya tiap kategori informasi punya warna sendiri yang konsisten.
  typeset -g P10K_NORD_POLAR='#4C566A'    # abu kebiruan redup / dimmed
  typeset -g P10K_NORD_POLAR_2='#3B4252'  # abu lebih gelap
  typeset -g P10K_NORD_FROST='#88C0D0'    # biru es utama — dir, prompt char
  typeset -g P10K_NORD_FROST_2='#81A1C1'  # biru es lebih dalam — git meta
  typeset -g P10K_NORD_FROST_3='#5E81AC'  # biru tua — tool/dev environment
  typeset -g P10K_NORD_SNOW='#ECEFF4'     # putih salju — teks terang
  typeset -g P10K_NORD_SNOW_2='#E5E9F0'   # putih redup
  typeset -g P10K_NORD_RED='#BF616A'      # error / konflik / low battery
  typeset -g P10K_NORD_ORANGE='#D08770'   # peringatan sedang / toolchain
  typeset -g P10K_NORD_YELLOW='#EBCB8B'   # perubahan / lambat / charging
  typeset -g P10K_NORD_GREEN='#A3BE8C'    # sukses / bersih / ok
  typeset -g P10K_NORD_PURPLE='#B48EAD'   # kontainer / orkestrasi / cloud

  # ───────────────────────── Tata letak prompt ──────────────────────
  # Baris 1: OS, direktori, Git, semua tool
  # dan environment aktif, plus konteks container/orkestrasi.
  # Baris 2: simbol prompt dan tempat mengetik command.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
    node_version
    pyenv
    virtualenv
    rust_version
    go_version
    php_version
    java_version
    docker_context
    kubecontext
    terraform
    newline
    prompt_char
  )

  # Rprompt berada di baris pertama. `newline` memastikan baris kedua kosong
  # di sisi kanan agar area mengetik command tetap lapang.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    ram
    load
    battery
    time
    newline
  )

  # ─────────────────────────── Gaya global ──────────────────────────
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR='  '
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  # Ikon selalu diwarnai sama seperti teks segmennya, bukan abu-abu netral,
  # supaya "banyak ikon" ini benar-benar terasa berwarna, bukan monoton.
  typeset -g POWERLEVEL9K_ICON_COLOR_ALWAYS=false

  # Tanpa garis/prefix penghubung agar kedua baris terlihat lebih minimal.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  # ─────────────────────── Logo sistem operasi ──────────────────────
  # Deteksi otomatis di bawah ini dibiarkan seperti semula (membaca
  # ID/ID_LIKE dari /etc/os-release untuk turunan Arch yang belum
  # dikenal p10k). Untuk Arch dan CachyOS sendiri, ikon dipaksa manual
  # ke logo Arch (), tidak bergantung pada deteksi otomatis.
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$P10K_NORD_FROST

  if [[ -r /etc/os-release ]]; then
    local os_release_lines=(${(f)"$(</etc/os-release)"})
    local id_lines=(${(@M)os_release_lines:#ID=*})
    local like_lines=(${(@M)os_release_lines:#ID_LIKE=*})
    local os_release_id os_release_like
    (( $#id_lines == 1 )) && os_release_id=${(Q)${id_lines[1]#ID=}}
    (( $#like_lines == 1 )) && os_release_like=${(Q)${like_lines[1]#ID_LIKE=}}

    case $os_release_id in
      arch|cachyos)
        # Manual: paksa logo Arch untuk kedua distro ini secara eksplisit,
        # tidak mengandalkan tabel bawaan p10k.
        typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
        ;;
      manjaro|artix|endeavouros)
        # Sudah punya ikon khusus sendiri di tabel bawaan Powerlevel10k.
        ;;
      *)
        [[ " $os_release_like " == *' arch '* ]] &&
          typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
        ;;
    esac
  fi

  # ─────────────────────────── Direktori ────────────────────────────
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$P10K_NORD_FROST
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$P10K_NORD_FROST_2
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$P10K_NORD_SNOW
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='󰉋 '
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='…'
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=true
  typeset -g POWERLEVEL9K_DIR_NOT_WRITABLE_FOREGROUND=$P10K_NORD_RED
  typeset -g POWERLEVEL9K_DIR_CLASSES=(
    '~' HOME '󰋜 '
    '~/*' HOME_SUBFOLDER '󰉋 '
    '*' DEFAULT '󰉋 '
  )
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND=$P10K_NORD_FROST
  typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$P10K_NORD_FROST

  # ─────────────────────────── Status Git ───────────────────────────
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_VCS_STASH_ICON='≡'
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='󰊢 '
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_EXPANSION='󰊢 '

  function p10k_nord_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g P10K_NORD_GIT_FORMAT=$P9K_CONTENT
      return
    fi

    local meta="%F{$P10K_NORD_FROST_2}"
    local clean="%F{$P10K_NORD_GREEN}"
    local changed="%F{$P10K_NORD_YELLOW}"
    local danger="%F{$P10K_NORD_RED}"
    local muted="%F{$P10K_NORD_POLAR}"

    if (( ! $1 )); then
      meta=$muted
      clean=$muted
      changed=$muted
      danger=$muted
    fi

    local result branch tag

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      (( $#branch > 32 )) && branch[13,-13]='…'
      result+="${meta}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -z $VCS_STATUS_LOCAL_BRANCH && -n $VCS_STATUS_TAG ]]; then
      tag=${(V)VCS_STATUS_TAG}
      (( $#tag > 32 )) && tag[13,-13]='…'
      result+="${meta}󰓹 ${tag//\%/%%}"
    fi

    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
      result+="${meta}󰜘 ${VCS_STATUS_COMMIT[1,8]}"

    (( VCS_STATUS_COMMITS_BEHIND )) && result+=" ${meta}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD  )) && result+=" ${meta}⇡${VCS_STATUS_COMMITS_AHEAD}"

    (( VCS_STATUS_STASHES        )) && result+=" ${changed}${(g::)POWERLEVEL9K_VCS_STASH_ICON}${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION     ]] && result+=" ${danger}⚠ ${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && result+=" ${danger}✘${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED     )) && result+=" ${changed}●${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && result+=" ${changed}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && result+=" ${changed}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && result+=" ${changed}─"

    if (( ! VCS_STATUS_STASHES &&
          ! VCS_STATUS_NUM_CONFLICTED &&
          ! VCS_STATUS_NUM_STAGED &&
          ! VCS_STATUS_NUM_UNSTAGED &&
          ! VCS_STATUS_NUM_UNTRACKED )) && [[ -z $VCS_STATUS_ACTION ]]; then
      result+=" ${clean}✓"
    fi

    typeset -g P10K_NORD_GIT_FORMAT=$result
  }
  functions -M p10k_nord_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((p10k_nord_git_formatter(1)))+${P10K_NORD_GIT_FORMAT}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((p10k_nord_git_formatter(0)))+${P10K_NORD_GIT_FORMAT}}'
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND,STASHES}_MAX_NUM=-1
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR=$P10K_NORD_FROST_2
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR=$P10K_NORD_POLAR
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$P10K_NORD_GREEN
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$P10K_NORD_YELLOW
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$P10K_NORD_YELLOW

  # ────────────── Versi Node.js, Python, Rust, Go, PHP, Java ─────────
  # Tiap bahasa dapat ikon Nerd Font khasnya sendiri; tool hanya muncul
  # saat relevan dengan project atau environment aktif.
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=$P10K_NORD_GREEN
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='󰎙 '

  typeset -g POWERLEVEL9K_PYENV_FOREGROUND=$P10K_NORD_YELLOW
  typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local)
  typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=false
  typeset -g POWERLEVEL9K_PYENV_VISUAL_IDENTIFIER_EXPANSION='󰌠 '
  typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_CONTENT:#$P9K_PYENV_PYTHON_VERSION(|/*)}:+ $P9K_PYENV_PYTHON_VERSION}'

  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$P10K_NORD_YELLOW
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=if-different
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
  typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='󰆧 '

  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=$P10K_NORD_ORANGE
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='󱘗 '

  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$P10K_NORD_FROST
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='󰟓 '

  typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND=$P10K_NORD_FROST_2
  typeset -g POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_PHP_VERSION_VISUAL_IDENTIFIER_EXPANSION='󰌟 '

  typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=$P10K_NORD_ORANGE
  typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_JAVA_VERSION_VISUAL_IDENTIFIER_EXPANSION='󰬷 '

  # ─────────────────────── Docker context aktif ─────────────────────
  typeset -g P10K_NORD_DOCKER_CONTEXT_CACHE=
  typeset -gi P10K_NORD_DOCKER_CONTEXT_CACHE_AT=-10

  function prompt_docker_context() {
    emulate -L zsh
    (( $+commands[docker] )) || return

    local docker_context=$DOCKER_CONTEXT
    if [[ -z $docker_context ]]; then
      if (( SECONDS - P10K_NORD_DOCKER_CONTEXT_CACHE_AT >= 5 )); then
        P10K_NORD_DOCKER_CONTEXT_CACHE=$(command docker context show 2>/dev/null)
        P10K_NORD_DOCKER_CONTEXT_CACHE_AT=$SECONDS
      fi
      docker_context=$P10K_NORD_DOCKER_CONTEXT_CACHE
    fi

    [[ -n $docker_context ]] || return
    p10k segment -f $P10K_NORD_PURPLE -i '󰡨' -t "${docker_context//\%/%%}"
  }
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_FOREGROUND=$P10K_NORD_PURPLE
  typeset -g POWERLEVEL9K_DOCKER_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='󰡨 '

  # ───────────────────────── Kubernetes & Terraform ──────────────────
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|flux|fluxctl|stern|kubeseal|skaffold'
  typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=$P10K_NORD_PURPLE
  typeset -g POWERLEVEL9K_KUBECONTEXT_VISUAL_IDENTIFIER_EXPANSION='󱃾 '
  typeset -g POWERLEVEL9K_KUBECONTEXT_CONTENT_EXPANSION='${P9K_KUBECONTEXT_CLOUD_NAME:+${P9K_KUBECONTEXT_CLOUD_NAME}/}${P9K_KUBECONTEXT_CLUSTER_NAME:-${P9K_KUBECONTEXT_NAME}}${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

  typeset -g POWERLEVEL9K_TERRAFORM_SHOW_ON_COMMAND='terraform|tf'
  typeset -g POWERLEVEL9K_TERRAFORM_FOREGROUND=$P10K_NORD_PURPLE
  typeset -g POWERLEVEL9K_TERRAFORM_VISUAL_IDENTIFIER_EXPANSION='󱁢 '

  # ───────────────────────── Simbol input ───────────────────────────
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$P10K_NORD_GREEN
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$P10K_NORD_RED
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '

  # ───────────────────────── Rprompt: status ────────────────────────
  # Sukses ditampilkan dengan ikon centang kecil, bukan disembunyikan total,
  # supaya baris kanan juga terasa "hidup" dengan ikon.
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=$P10K_NORD_GREEN
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='󰸞 '
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=$P10K_NORD_GREEN
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='󰸞 '
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$P10K_NORD_RED
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='󰅙 '
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=$P10K_NORD_RED
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='󰅙 '
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=$P10K_NORD_RED
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='󰅙 '

  # ───────────────────── Rprompt: waktu eksekusi ────────────────────
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$P10K_NORD_YELLOW
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='󰔟 '

  # ───────────────────── Rprompt: background jobs ───────────────────
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=true
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$P10K_NORD_FROST_2
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='󰜎 '

  # ───────────────────── Rprompt: RAM & load average ─────────────────
  typeset -g POWERLEVEL9K_RAM_FOREGROUND=$P10K_NORD_FROST_2
  typeset -g POWERLEVEL9K_RAM_VISUAL_IDENTIFIER_EXPANSION='󰍛 '

  typeset -g POWERLEVEL9K_LOAD_WHICH=5
  typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=$P10K_NORD_GREEN
  typeset -g POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_EXPANSION='󰓅 '
  typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=$P10K_NORD_YELLOW
  typeset -g POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_EXPANSION='󰓅 '
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=$P10K_NORD_RED
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_EXPANSION='󰓅 '

  # ───────────────────────── Rprompt: baterai ────────────────────────
  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
  typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=$P10K_NORD_RED
  typeset -g POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND=$P10K_NORD_YELLOW
  typeset -g POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND=$P10K_NORD_GREEN
  typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=$P10K_NORD_SNOW_2
  typeset -ga POWERLEVEL9K_BATTERY_STAGES=(
    '󰁺 ' '󰁻 ' '󰁼 ' '󰁽 ' '󰁾 ' '󰁿 ' '󰂀 ' '󰂁 ' '󰂂 ' '󰁹 '
  )
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=true
  typeset -g POWERLEVEL9K_BATTERY_HIDE_ABOVE_LEVEL=97
  typeset -g POWERLEVEL9K_BATTERY_HIDE_ON_AC=false

  # ───────────────────────── Rprompt: jam ───────────────────────────
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$P10K_NORD_SNOW
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION='󰥔 '

  # ─────────────────────── Perilaku Powerlevel10k ───────────────────
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' p10k_config_opts
