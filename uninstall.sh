#!/usr/bin/env bash

set -Eeuo pipefail
shopt -s nullglob

# ==========================================
# uninstall.sh — gentle rice uninstaller without sudo
# By default runs in DRY-RUN mode (don't make any changes)
# To apply changes: ./install.sh --apply
# Usefull flags: -y/--yes (don't ask), -f/--force (overwrite),
# ==========================================

DRY_RUN=1
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
BACKUPS_LIST_PATH="$SCRIPT_DIR/backups.tsv"

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

uninstall_configs() {
    log "Uninstalling configs..."
    local target_dir="$SCRIPT_DIR/dotfiles/.config"

    for conf in "$target_dir"/*; do
        [[ -e "$conf" ]] || continue
        while IFS= read -r link; do
            [[ "$(readlink -f "$link")" == "$conf" ]] && run rm "$link"
        done < <(find ~/.config -type l)
        log "Config $conf uninstalled"
    done

    while IFS= read -r -d '' conf; do
        while IFS= read -r link; do
            [[ "$(readlink -f "$link")" == "$conf" ]] && run rm "$link"
        done < <(find ~/.config -type l)
    done < <(find "$SCRIPT_DIR/dotfiles" -maxdepth 1 -type f -print0)
}

uninstall_local_bin() {
    log "Uninstalling scripts..."
    local target_dir="$SCRIPT_DIR/dotfiles/.local/bin"

    for script in "$target_dir"/*; do
        [[ -e "$script" ]] || continue
        local name
        name=$(basename -- "$script")
        while IFS= read -r link; do
            [[ "$(readlink -f "$link")" == "$script" ]] && run rm "$link"
        done < <(find ~/.local/bin -type l)
        log "Script $name uninstalled"
    done
}

uninstall_submodule_scripts() {
    log "Uninstalling scripts from submodules..."
    local base="$SCRIPT_DIR/scripts"
    [[ -d "$base" ]] || { warn "No submodule scripts directory"; return 0; }

    for dir in "$base"/*; do
        [ -d "$dir" ] || continue

        while IFS= read -r -d '' script; do
            local name
            name=$(basename -- "$script")
            while IFS= read -r link; do
                [[ "$(readlink -f "$link")" == "$script" ]] && run rm "$link"
            done < <(find ~/.local/bin -type l)
            log "Script $name uninstalled"
        done < <(find "$dir" -maxdepth 2 -type f -perm -u+x -print0)
    done
}

uninstall_themix() {
    log "Uninstalling themix..."

    run rm "$HOME/.local/share/themix/oomox-gtk-theme"
    run rm "$HOME/.local/share/themix/archdroid-icon-theme"
}

uninstall_suckless_programs() {
    log "Uninstalling suckless programs..."
    local base="$SCRIPT_DIR/suckless"
    [[ -d "$base" ]] || { warn "No suckless directory"; return 0; }

    for dir in "$base"/*; do
        [ -d "$dir" ] || continue

        while IFS= read -r -d '' bname; do
            local name
            name=$(basename -- "$bname")
            while IFS= read -r link; do
                [[ "$(readlink -f "$link")" == "$bname" ]] && run rm "$link"
            done < <(find ~/.local/bin -type l)
            log "Program $name uninstalled"
        done < <(find "$dir" -maxdepth 1 -type f -perm -u+x -print0)
    done
}

revert_backups() {
    log "Reverting backups..."
    [[ -f "$BACKUPS_LIST_PATH" ]] || { warn "backups.tsv not found"; return 0; }

    while IFS=$'\t' read -r original backup; do
        run mv -- "$backup" "$original"
        log "Revert backup: $backup -> $original"
    done < "$BACKUPS_LIST_PATH"
}

usage() {
    cat <<USAGE
Usage: ./uninstall.sh [options]

Options:
  --apply Apply changes (disable dry-run)
  -h, --help Show this help
USAGE
}

main() {
    local arg
    while [[ $# -gt 0 ]]; do
        arg="$1"; shift || true
        case "$arg" in
            --apply) DRY_RUN=0 ;;
            -h|--help) usage; exit 0 ;;
            *) warn "Unknown option: $arg" ;;
        esac
    done

    uninstall_configs
    uninstall_local_bin
    uninstall_suckless_programs
    uninstall_submodule_scripts
    revert_backups

    if (( DRY_RUN )); then
        warn "DRY-RUN mode: no changes were made. Re-run with --apply to actually modify files."
    else
        log "Done."
    fi
}

main "$@"
