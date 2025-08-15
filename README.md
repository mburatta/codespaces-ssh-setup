# Collegarti a un GitHub Codespace con JetBrains Gateway (via SSH + gh)

Per usare JetBrains Gateway (IntelliJ, WebStorm, PyCharm, ecc.) con un GitHub Codespace, è necessario che il tunnel SSH venga gestito da GitHub CLI (`gh`). Di seguito i passaggi consigliati e robusti.

---

## 1) Prerequisiti

- GitHub CLI (`gh`) → https://cli.github.com/
- JetBrains Gateway (standalone o tramite JetBrains Toolbox)
- Nessuna configurazione speciale lato Codespace: Gateway installerà automaticamente il backend IDE al primo accesso.

---

## 2) Autenticazione con GitHub CLI

```bash
gh auth login
```

- Seleziona GitHub.com
- Accedi via browser quando richiesto
- La scelta del protocollo per Git (HTTPS/SSH) non incide sul funzionamento di Codespaces via `gh`.

Puoi verificare di essere autenticato con:
```bash
gh auth status
```

---

## 3) Preparare la configurazione SSH dei Codespaces

1. (Facoltativo) Elenca i Codespaces disponibili:
   ```bash
   gh codespace list
   ```

2. Genera/aggiorna un file SSH dedicato ai Codespaces:
   ```bash
   gh codespace ssh --config > ~/.ssh/codespaces
   ```

3. Assicurati che il tuo `~/.ssh/config` includa il file dedicato (aggiungi questa riga una sola volta):
   ```bash
   printf "Include ~/.ssh/codespaces\n" >> ~/.ssh/config
   ```

Dopo il passaggio 2, nel file `~/.ssh/codespaces` troverai voci del tipo:
```ini
Host cool-lemur-ab12cd
  User codespace
  HostName ...
  IdentityFile ...
  ProxyCommand ...
```

Suggerimento: prima di usare Gateway, prova la connessione SSH dal terminale:
```bash
ssh cool-lemur-ab12cd
```

---

## 4) Connessione con JetBrains Gateway

1. Apri JetBrains Gateway
2. Seleziona “Connect via SSH”
3. Nel campo Host inserisci l’alias dal tuo `~/.ssh/config`, ad esempio:
   ```bash
   cool-lemur-ab12cd
   ```
4. Il campo User in genere non serve (è già definito in config come `codespace`)
5. Procedi: Gateway si connetterà e installerà il backend IDE sul Codespace
6. Seleziona l’IDE JetBrains da usare (IntelliJ, WebStorm, ecc.)

---

## 5) Note importanti

- Gli endpoint dei Codespaces possono cambiare dopo sospensione/riattivazione. In tal caso rigenera il file:
  ```bash
  gh codespace ssh --config > ~/.ssh/codespaces
  ```
  (Non è necessario ri-modificare `~/.ssh/config` se hai già aggiunto l’Include.)

- Automazione consigliata: esegui il comando qui sopra prima di aprire Gateway, oppure crea uno script/alias che aggiorna la configurazione e poi avvia Gateway.

Hai bisogno di uno script Bash che faccia tutto in un colpo solo? Posso prepararlo.
