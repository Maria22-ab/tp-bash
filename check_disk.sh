#!/bin/bash
# check_disk.sh - Alerte si l'espace disque dépasse un seuil (80% par défaut)

SEUIL="${1:-80}"
UTILISATION=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : disque utilisé à ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 1
else
    echo "OK : disque utilisé à ${UTILISATION}% (seuil : ${SEUIL}%)"
    exit 0
fi
