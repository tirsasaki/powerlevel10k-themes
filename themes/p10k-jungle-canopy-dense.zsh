# Jungle Canopy Dense - tema Powerlevel10k (Versi Block/Segmented, halus)
# Warna: hijau tua, daun, lumut, lime — dense seperti kanopi hutan lebat,
# dengan kontras lebih hidup dibanding versi block sebelumnya.
# Gaya: setiap segmen punya background sendiri, dipisah separator BULAT/HALUS
# (bukan panah tajam), seperti kapsul pil yang menyatu antar segmen.
#
# Pemakaian:
#   1. Simpan sebagai ~/.p10k.zsh
#   2. Pastikan di ~/.zshrc ada:  [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
#   3. Hapus cache lalu mulai ulang shell:
#        rm -f ~/.cache/p10k-instant-prompt-*.zsh && exec zsh
#   PENTING: versi block butuh Nerd Font (karakter separator bulat U+E0B4-E0B7)
#   agar tidak tampil sebagai kotak. user@host sengaja disembunyikan.
#
# Peta ikon: sama seperti Pure, tapi setiap ikon kini duduk di dalam block
# berwarna solid. Garis titik-titik (ruler) dipakai sebagai pemisah tipis
# sebelum prompt baru — lihat catatan di file jungle-canopy-pure.p10k.zsh
# soal kenapa p10k tidak bisa membuat celah dinamis di baris yang sama.

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m 'POWERLEVEL9K_*~POWERLEVEL9K_GITSTATUS_DIR'

  autoload -Uz is-at-least && is-at-least 5.1 || return

  # ---------- Palet warna (256-color) ----------
  # Background block: hijau yang lebih hidup dan kontras, dari gelap ke terang
  local bg_canopy=22       # hijau tua kanopi (paling dalam)
  local bg_leaf=28         # hijau daun yang lebih kaya (bukan abu-abu)
  local bg_moss=34         # hijau lumut segar
  local bg_lime=118        # hijau lime cerah (bukan olive pudar)
  local bg_shadow=23       # hijau kehitaman untuk waktu (bukan abu-abu polos)
  # Foreground di atas block — putih bersih di gelap, hijau tua di terang
  local fg_mint=194
  local fg_cream=231       # putih bersih, kontras lebih tegas di block gelap
  local fg_ondark=231
  local fg_onlight=22
  local jungle_red=160

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
    virtualenv
    node_version
    time
  )

  # ---------- Gaya dasar: BLOCK dengan separator bulat/halus (bukan panah tajam) ----------
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B4'
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B6'
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=$'\uE0B5'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=$'\uE0B7'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=$'\uE0B4'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=$'\uE0B6'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION='${P9K_VISUAL_IDENTIFIER}'
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{'$bg_shadow'}╰─%f '

  # ---------- Ruler: garis titik-titik tipis sebagai pemisah ----------
  typeset -g POWERLEVEL9K_SHOW_RULER=true
  typeset -g POWERLEVEL9K_RULER_CHAR='·'
  typeset -g POWERLEVEL9K_RULER_FOREGROUND=$bg_shadow

  # ---------- Penanda prompt ----------
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VIOWR,VIVIS}_CONTENT_EXPANSION='🌿'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='🐛'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VIOWR,VIVIS,VICMD}_CONTENT_EXPANSION='🍂'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=$bg_leaf
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=

  # ---------- OS icon block ----------
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=$bg_canopy
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=$fg_ondark

  # ---------- Direktori block ----------
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=$bg_leaf
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=$fg_ondark
  typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION='🌴'
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER='(.git|package.json|Cargo.toml|go.mod|pyproject.toml)'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=$fg_mint
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=$fg_cream
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=60

  # ---------- Git block ----------
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_BACKGROUND=$bg_moss
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='🌱'
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$fg_onlight
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$fg_onlight
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$bg_canopy
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=$fg_onlight
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=false

  # ---------- Status block (tampil hanya saat error) ----------
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=$jungle_red
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$fg_cream
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'

  # ---------- Durasi perintah block ----------
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=$bg_lime
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$fg_onlight
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='⏳'

  # ---------- Background jobs block ----------
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=$bg_shadow
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=$fg_mint
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='🦋'

  # ---------- Bahasa pemrograman block (muncul hanya di folder proyek) ----------
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=$bg_moss
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=$fg_onlight
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='🌾'

  typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=$bg_leaf
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=$fg_ondark
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='🌳'

  # ---------- Jam block ----------
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=$bg_canopy
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=$fg_mint
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