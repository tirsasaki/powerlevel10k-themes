# Jungle Canopy Pure - tema Powerlevel10k
# Warna: hijau tua, lumut, daun, lime — murni hijau tanpa aksen warna lain.
# Gaya: lean, tanpa background block.
#
# Catatan soal "dot connector": p10k tidak mencetak spasi di antara sisi kiri
# dan kanan prompt (posisi kanan dipindah lewat kode kursor terminal), jadi
# tidak ada celah asli yang bisa diganti titik-titik secara dinamis mengikuti
# lebar terminal. Sebagai gantinya dipakai RULER: garis titik-titik tipis
# selebar terminal, tampil sebagai pemisah sebelum prompt baru.
#
# Pemakaian:
#   1. Simpan sebagai ~/.p10k.zsh
#   2. Pastikan di ~/.zshrc ada:  [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#   3. Hapus cache lalu mulai ulang shell:
#        rm -f ~/.cache/p10k-instant-prompt-*.zsh && exec zsh
#   (user@host disembunyikan di versi Pure ini, jadi DEFAULT_USER tidak perlu diisi)
#
# Peta ikon:
#   🌿 prompt sukses      🍂 prompt gagal     🐛 mode vi command
#   🌴 direktori          🌱 git              🦎 sesi SSH        🐍 root
#   🌾 Python venv        🌳 Node.js          🌵 Go              🍄 Rust
#   ⏳ durasi perintah    🦋 background job   🌙 jam

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # DEFAULT_USER sengaja tidak dihapus supaya context user@host bisa dipakai
  unset -m 'POWERLEVEL9K_*~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.1 || return

  # ---------- Palet warna (256-color) ----------
  local jungle_deep=22     # hijau tua (kanopi paling dalam)
  local jungle_moss=65     # hijau lumut
  local jungle_leaf=71     # hijau daun
  local jungle_lime=107    # hijau lime
  local jungle_olive=100   # hijau zaitun
  local jungle_mint=121    # hijau mint terang (aksen)
  local jungle_dim=238     # abu-abu kehijauan redup (untuk ruler & teks pudar)
  local jungle_red=160     # merah untuk error

  # ---------- Elemen prompt ----------
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
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

  # ---------- "Dot connector" via ruler: garis titik-titik tipis selebar
  # terminal, dipakai sebagai pemisah sebelum prompt baru. Warna redup
  # (jungle_dim) supaya tidak terlalu terang. Lihat catatan di atas file.
  typeset -g POWERLEVEL9K_SHOW_RULER=true
  typeset -g POWERLEVEL9K_RULER_CHAR='·'
  typeset -g POWERLEVEL9K_RULER_FOREGROUND=$jungle_dim

  # ---------- Penanda prompt ----------
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VIOWR,VIVIS}_CONTENT_EXPANSION='🌿'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='🐛'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VIOWR,VIVIS,VICMD}_CONTENT_EXPANSION='🍂'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$jungle_leaf
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true

  # ---------- OS icon ----------
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$jungle_leaf

  # ---------- Root ----------
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=$jungle_red
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_VISUAL_IDENTIFIER_EXPANSION='🐍'

  # ---------- Direktori ----------
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$jungle_leaf
  typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='🌴'
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.git|package.json|Cargo.toml|go.mod|pyproject.toml)'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$jungle_dim
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$jungle_mint
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80

  # ---------- Git ----------
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='🌱'
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$jungle_mint
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$jungle_olive
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$jungle_lime
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=245
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=false

  # ---------- Status (tampil hanya saat error) ----------
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$jungle_red
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

  # ---------- Durasi perintah ----------
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$jungle_olive
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='⏳'

  # ---------- Background jobs ----------
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$jungle_lime
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='🦋'

  # ---------- Bahasa pemrograman (muncul hanya di folder proyek) ----------
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$jungle_lime
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='🌾'

  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=$jungle_leaf
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='🌳'

  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=$jungle_moss
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='🌵'

  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=$jungle_olive
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='🍄'

  # ---------- Jam ----------
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$jungle_dim
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION='🌙'

  # ---------- Lain-lain ----------
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'