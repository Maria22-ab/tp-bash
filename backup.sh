#!/bin/bash
# backup.sh - Archive un dossier, horodate, supprime les sauvegardes > 7 jours
set -Eeuo pipefail

DOSSIER="${1:-}"
DEST="${2:-$HOME/backups}"
LOG="${3:-$HOME/tp-bash/backup.log}"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

if [ -z "$DOSSIER" ]; then
    echo "Usage : $0 <dossier_source> [dossier_dest]" >&2
    exit 1
fi

if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier '$DOSSIER' n'existe pas." >&2
    exit 1
fi

mkdir -p "$DEST"
ARCHIVE="$DEST/backup_${DATE}.tar.gz"

log "Début de la sauvegarde de $DOSSIER"
tar -czf "$ARCHIVE" "$DOSSIER"
log "Sauvegarde OK : $ARCHIVE"

# Suppression des sauvegardes de plus de 7 jours
for fichier in "$DEST"/backup_*.tar.gz; do
    [ -e "$fichier" ] || continue
    if [ -n "$(find "$fichier" -mtime +7)" ]; then
        rm "$fichier"
        log "Ancienne sauvegarde supprimée : $fichier"
    fi
done

log "Fin du script."
exit 0
