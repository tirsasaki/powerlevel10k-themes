# Sakura Blossom Prompt - tema Powerlevel10k
# Warna: pink, magenta, hijau daun. Penanda prompt: bunga sakura.
#
# Pemakaian:
#   1. Simpan sebagai ~/.p10k.zsh (atau file lain)
#   2. Pastikan di ~/.zshrc ada:  source ~/.p10k.zsh
#   3. Buka terminal baru atau jalankan:  source ~/.zshrc

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.1 || return

  # ---------- Palet warna (256-color) ----------
  local sakura_light=218   # pink pastel
  local sakura_pink=211    # pink sakura
  local sakura_deep=205    # pink tua
  local sakura_magenta=213 # magenta lembut
  local sakura_leaf=107    # hijau daun
  local sakura_leaf_light=114
  local sakura_mute=181    # pink keabu-abuan
  local sakura_red=160     # merah untuk error

  # ---------- Elemen prompt ----------
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
    newline
    prompt_char
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    time
  )

  # ---------- Gaya dasar (lean, tanpa background) ----------
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=

  # ---------- Penanda prompt: bunga sakura ----------
  # Normal (sukses)
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VIOWR,VIVIS}_CONTENT_EXPANSION='🌸'
  # Mode vi command
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='🍃'
  # Perintah terakhir gagal (bunga layu)
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VIOWR,VIVIS,VICMD}_CONTENT_EXPANSION='🥀'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$sakura_pink
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true

  # ---------- OS icon ----------
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$sakura_light

  # ---------- Direktori ----------
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$sakura_pink
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.git|package.json|Cargo.toml|go.mod|pyproject.toml)'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$sakura_mute
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$sakura_deep
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80

  # ---------- Git ----------
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$sakura_leaf_light
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$sakura_leaf
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$sakura_magenta
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=245
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=false

  # ---------- Status (tampil hanya saat error) ----------
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$sakura_red
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

  # ---------- Durasi perintah ----------
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$sakura_magenta

  # ---------- Background jobs ----------
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$sakura_leaf

  # ---------- Jam ----------
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$sakura_mute
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  # ---------- Lain-lain ----------
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'