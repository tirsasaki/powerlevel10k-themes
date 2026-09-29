# Lunar Eclipse - tema Powerlevel10k (versi terang untuk terminal dark)
# Warna: biru terang dan kuning terang, seperti cahaya bulan di langit malam.
# Ikon: hanya bulan yang terang, tanpa 🌑 / 🌘 yang hilang di latar gelap.
#
# Pemakaian:
#   1. Simpan sebagai ~/.p10k.zsh (cadangkan config lama dulu kalau perlu)
#   2. Pastikan di ~/.zshrc ada:  [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#   3. Hapus cache lalu mulai ulang shell:
#        rm -f ~/.cache/p10k-instant-prompt-*.zsh && exec zsh
#
# Peta ikon:
#   🌙 prompt sukses      💫 prompt gagal     🌛 mode vi command
#   🌕 direktori          🌠 git              🔭 sesi SSH        🩸 root
#   🌓 Python venv        🌔 Node.js          🌖 Go              🌗 Rust
#   ⏳ durasi perintah    🌀 background job   ✨ jam

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # DEFAULT_USER sengaja tidak dihapus supaya tetap bisa diatur dari ~/.zshrc
  unset -m 'POWERLEVEL9K_*~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.1 || return

  # ---------- Palet warna (256-color) ----------
  # Kuning terang
  local moon_yellow=227    # kuning terang (warna utama)
  local moon_gold=221      # kuning keemasan
  local moon_cream=229     # krem terang
  # Biru terang
  local moon_sky=117       # biru langit terang
  local moon_ice=153       # biru es pucat
  local moon_blue=111      # biru lembut
  local moon_cyan=123      # cyan terang
  # Peringatan
  local moon_red=203       # merah terang (terbaca di latar gelap)

  # ---------- Elemen prompt ----------
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    ssh
    root_indicator
    dir
    vcs
    newline
    prompt_char
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    virtualenv
    node_version
    go_version
    rust_version
    time
  )

  # ---------- Gaya dasar (lean, tanpa background) ----------
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=

  # ---------- Penanda prompt ----------
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VIOWR,VIVIS}_CONTENT_EXPANSION='🌙'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='🌛'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VIOWR,VIVIS,VICMD}_CONTENT_EXPANSION='💫'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$moon_yellow
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true

  # ---------- OS icon ----------
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$moon_sky

  # ---------- SSH dan root ----------
  typeset -g POWERLEVEL9K_SSH_FOREGROUND=$moon_gold
  typeset -g POWERLEVEL9K_SSH_VISUAL_IDENTIFIER_EXPANSION='🔭'
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=$moon_red
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_VISUAL_IDENTIFIER_EXPANSION='🩸'

  # ---------- Direktori ----------
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$moon_yellow
  typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='🌕'
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.git|package.json|Cargo.toml|go.mod|pyproject.toml)'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$moon_blue
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$moon_cream
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80

  # ---------- Git ----------
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='🌠'
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$moon_sky
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$moon_ice
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$moon_gold
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=245
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=false

  # ---------- Status (tampil hanya saat error) ----------
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$moon_red
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

  # ---------- Durasi perintah ----------
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$moon_gold
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='⏳'

  # ---------- Background jobs ----------
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$moon_cyan
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='🌀'

  # ---------- Bahasa pemrograman (muncul hanya di folder proyek) ----------
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$moon_sky
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='🌓'

  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=$moon_ice
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='🌔'

  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$moon_cyan
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='🌖'

  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=$moon_cream
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='🌗'

  # ---------- Jam ----------
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$moon_blue
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION='✨'

  # ---------- Lain-lain ----------
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'