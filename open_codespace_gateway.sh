#!/bin/bash

# Controlla che GitHub CLI sia installato
if ! command -v gh &> /dev/null; then
    echo "❌ Errore: GitHub CLI (gh) non trovato. Installalo da https://cli.github.com/"
    exit 1
fi

# Lista dei Codespaces attivi
echo "📦 Lista Codespaces disponibili:"
gh codespace list

# Chiede il nome del Codespace
read -p "✏️ Inserisci il nome del Codespace da aprire: " CODESPACE_NAME

# Aggiorna la configurazione SSH
echo "🔄 Aggiornamento configurazione SSH..."
gh codespace ssh --config -c "$CODESPACE_NAME" > ~/.ssh/codespaces_config

# Unisce la configurazione al file ~/.ssh/config
# (Se vuoi mantenere pulito, puoi rimuovere eventuali vecchie voci prima)
grep -v "Host $CODESPACE_NAME" ~/.ssh/config > ~/.ssh/config.tmp || true
cat ~/.ssh/codespaces_config >> ~/.ssh/config.tmp
mv ~/.ssh/config.tmp ~/.ssh/config

echo "✅ Configurazione SSH aggiornata per $CODESPACE_NAME"

# Avvia JetBrains Gateway (modifica il percorso se necessario)
JETBRAINS_GATEWAY="/opt/jetbrains-gateway/bin/gateway.sh"  # Linux
# Per macOS: JETBRAINS_GATEWAY="/Applications/JetBrains Gateway.app/Contents/MacOS/jetbrains-gateway"

if [ ! -f "$JETBRAINS_GATEWAY" ]; then
    echo "⚠️ JetBrains Gateway non trovato. Aprilo manualmente e seleziona host: $CODESPACE_NAME"
    exit 0
fi

# Avvia Gateway con il collegamento SSH
"$JETBRAINS_GATEWAY" --ssh "$CODESPACE_NAME"

echo "🚀 JetBrains Gateway avviato!"
