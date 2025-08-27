#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s nullglob

# ==========================================
# install.sh — gentle rice installer without sudo
# By default runs in DRY-RUN mode (don't make any changes)
# To apply changes: ./install.sh --apply
# Usefull flags: -y/--yes (don't ask), -f/--force (overwrite),
# --remote-submodules (update submodules from remote branches)
# ==========================================

DRY_RUN=1
YES=0
FORCE=0
REMOTE_SUBMODULES=0
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
BACKUPS_LIST_PATH="$SCRIPT_DIR/backups.tsv"
DEPENDENCIES=(dunst rofi make git xdotool gcc feh)

log() { printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[~]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[!]\033[0m %s\n" "$*"; exit 1; }

trap 'printf "\n"; err "Interrupted by user"' INT

run() {
    if (( DRY_RUN )); then
        printf '[dry]'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

confirm() {
    if (( YES )); then return 0; fi
    local q="$1" response

    read -r -p "$q [y/N] " response || true
    case "$response" in
        [yY]|[yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
}

backup_path() {
    local path="$1"

    if [[ -e "$path" || -L "$path" ]]; then
        local ts
        ts=$(date +%Y%m%d-%H%M%S)
        local bak="${path}.bak.${ts}"

        run mv -- "$path" "$bak"
        run printf "%s\t%s\n" "$path" "$bak" >> "$BACKUPS_LIST_PATH"
        log "Backup: $path -> $bak"
    fi
}

check_dependencies() {
    local missing=()

    for dep in "${DEPENDENCIES[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done

    if ((${#missing[@]})); then
        err "Missing dependencies: ${missing[*]}"
    fi

    log "Requirements satisfied"
}

create_symlink() {
    local target="$1" link="$2"
    mkdir -p -- "$(dirname -- "$link")"

    if [[ -L "$link" && "$(readlink -- "$link")" == "$target" ]]; then
        log "Symlink $link already exists → skip"
        return
    fi

    if [[ -e "$link" || -L "$link" ]]; then
        if (( FORCE )); then
            backup_path "$link"
        else
            if confirm "$link exists. Backup and replace?"; then
                backup_path "$link"
            else
                warn "Skip link: $link"
                return 0    
            fi
        fi
    fi

    run ln -s -- "$target" "$link"
    log "Linked: $link -> $target"
}

install_configs() {
    log "Installing configs..."
    mkdir -p -- "$HOME/.config"
    local target_dir="$SCRIPT_DIR/dotfiles/.config"

    for conf in "$target_dir"/*; do
        [[ -e "$conf" ]] || continue
        local name
        name=$(basename -- "$conf")
        create_symlink "$conf" "$HOME/.config/$name"
    done

    while IFS= read -r -d '' conf; do
        local name
        name=$(basename -- "$conf")
        create_symlink "$conf" "$HOME/$name"
    done < <(find "$SCRIPT_DIR/dotfiles" -maxdepth 1 -type f -print0)
}

install_local_bin() {
    log "Installig scripts..."
    mkdir -p "$HOME/.local/bin"
    local target_dir="$SCRIPT_DIR/dotfiles/.local/bin"
    
    for script in "$target_dir"/*; do
        [[ -e "$script" ]] || continue
        local name
        name=$(basename -- "$script")
        create_symlink "$script" "$HOME/.local/bin/$name"
    done
}

install_submodule_scripts() {
    log "Installing scripts from submodules..."
    local base="$SCRIPT_DIR/scripts"
    [[ -d "$base" ]] || { warn "No submodule scripts directory"; return 0; }
    
    create_symlink "$base/dunst-media-control/media-control" "$HOME/.local/bin/media-control"
    create_symlink "$base/rofi-mixer/src/rofi-mixer" "$HOME/.local/bin/rofi-mixer"
    create_symlink "$base/wal-telegram/wal-telegram" "$HOME/.local/bin/wal-telegram"
}

install_themix_scripts() {
    log "Installing themix scripts..."
    local base="$SCRIPT_DIR/scripts"
    [[ -d "$base" ]] || { warn "No submodule scripts directory"; return 0; }

    create_symlink "$base/oomox-gtk-theme/change_color.sh" "$HOME/.local/bin/themix-oomox-gtk-theme"
    create_symlink "$base/archdroid-icon-theme/change_color.sh" "$HOME/.local/bin/themix-archdroid-icon-theme"
}

suckless_injection() {
    log "Building suckless programs..."
    local root="$SCRIPT_DIR/suckless"
    [[ -d "$root" ]] || { warn "No suckless directory"; return 0; }

    for dir in "$root"/*; do
        [ -d "$dir" ] || continue

        local name
        name=$(basename -- "$dir")
        run make -C "$dir"
        log "$name built successfully"

        while IFS= read -r -d '' bin; do
            local bname
            bname=$(basename -- "$bin")
            create_symlink "$bin" "$HOME/.local/bin/$bname"
        done < <(find "$dir" -maxdepth 1 -type f -perm -u+x -print0)
    done
}

ensure_local_bin_on_path() {
    case ":$PATH:" in
        *":$HOME/.local/bin:") : ;;
        *)
          warn "~/.local/bin is not in PATH"
          printf '\nAdd this to your shell rc (e.g. ~/.bashrc or ~/.zshrc):\n'
          printf ' export PATH="$HOME/.local/bin:$PATH"\n\n'
          ;;
    esac
}

update_submodules() {
    if (( REMOTE_SUBMODULES )); then
        log "Updating submodules (remote)"
        run git submodule update --init --recursive --remote
    else
        log "Updating submodules"
        run git submodule update --init --recursive
    fi
}

usage() {
    cat <<USAGE
Usage: ./install.sh [options]

Options:
  --apply Apply changes (disable dry-run)
  -y, --yes Assume "yes" for prompts
  -f, --force Force replace existing files (backup with timestamp)
  --remote-submodules Update submodules from their tracked branches
  -h, --help Show this help
USAGE
}

main() {
    local arg
    while [[ $# -gt 0 ]]; do
        arg="$1"; shift || true
        case "$arg" in
            --apply) DRY_RUN=0 ;;
            -y|--yes) YES=1 ;;
            -f|--force) FORCE=1 ;;
            --remote-submodules) REMOTE_SUBMODULES=1 ;;
            -h|--help) usage; exit 0 ;;
            *) warn "Unknown option: $arg" ;;
        esac
    done
    
    [[ -e "$BACKUPS_LIST_PATH" ]] && run rm -- "$BACKUPS_LIST_PATH"
    check_dependencies
    update_submodules
    install_configs
    install_local_bin
    suckless_injection
    install_submodule_scripts
    install_themix_scripts
    ensure_local_bin_on_path

    if (( DRY_RUN )); then
        warn "DRY-RUN mode: no changes were made. Re-run with --apply to actually modify files."
    else
        log "Done."
    fi
}

main "$@"
