
#!/bin/bash
# ci.sh - Mini pipeline CI : clone/pull, tests, logs horodatés
set -Eeuo pipefail

REPO_URL="${1:-}"
WORKDIR="${2:-$HOME/ci-workspace}"
LOG="$HOME/tp-bash/ci.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

if [ -z "$REPO_URL" ]; then
    echo "Usage : $0 <url_depot> [dossier_travail]" >&2
    exit 1
fi

update_repo() {
    if [ -d "$WORKDIR/.git" ]; then
        log "Mise à jour du dépôt (git pull)"
        git -C "$WORKDIR" pull
    else
        log "Clonage de $REPO_URL"
        git clone "$REPO_URL" "$WORKDIR"
    fi
}

run_tests() {
    log "Exécution des tests..."
    # Tests simulés : adapte selon ton dépôt
    [ -d "$WORKDIR" ] || return 1
    ls "$WORKDIR" > /dev/null
    log "Tests réussis"
}

trap 'log "ÉCHEC du pipeline"; exit 1' ERR

log "=== Début du pipeline ==="
update_repo
run_tests
log "=== Pipeline terminé avec succès ==="
exit 0
