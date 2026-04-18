#!/bin/bash

# MD Vault Quick Push
# Uso: ./vault-push.sh "Sua mensagem"
# Ou: ./vault-push.sh (usa timestamp)

set -e

VAULT_DIR="$HOME/md-vault"

if [ -n "$1" ]; then
    MESSAGE="$1"
else
    MESSAGE="Update: $(date '+%Y-%m-%d %H:%M:%S')"
fi

echo "📝 Pushando alterações..."
cd "$VAULT_DIR"

if git status --porcelain | grep -q .; then
    git add -A
    git commit -m "$MESSAGE"
    git push origin master
    echo "✓ Push realizado: $MESSAGE"
else
    echo "ℹ Nenhuma mudança para fazer push"
fi
