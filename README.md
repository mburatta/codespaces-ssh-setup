# Connect to a GitHub Codespace with JetBrains Gateway (via SSH + gh)

To use JetBrains Gateway (IntelliJ, WebStorm, PyCharm, etc.) with a GitHub Codespace, the SSH tunnel must be managed by the GitHub CLI (`gh`). Below are the recommended and reliable steps.

---

## 1) Prerequisites

- GitHub CLI (`gh`) → https://cli.github.com/
- JetBrains Gateway (standalone or via JetBrains Toolbox)
- No special configuration is required on the Codespace side: Gateway will automatically install the IDE backend on first access.

---

## 2) Authentication with GitHub CLI

```bash
gh auth login
```

- Select GitHub.com
- Log in via browser when prompted
- The choice of Git protocol (HTTPS/SSH) does not affect how Codespaces works via `gh`.

You can verify that you are authenticated with:
```bash
gh auth status
```

---

## 3) Prepare the SSH configuration for Codespaces

1. (Optional) List the available Codespaces:
   ```bash
   gh codespace list
   ```

2. Generate/update a dedicated SSH config file for Codespaces:
   ```bash
   gh codespace ssh --config > ~/.ssh/codespaces
   ```

3. Ensure that your `~/.ssh/config` includes the dedicated file (add this line only once):
   ```bash
   printf "Include ~/.ssh/codespaces\n" >> ~/.ssh/config
   ```

After step 2, in the file `~/.ssh/codespaces` you will find entries like:
```ini
Host cool-lemur-ab12cd
  User codespace
  HostName ...
  IdentityFile ...
  ProxyCommand ...
```

Tip: before using Gateway, test the SSH connection from the terminal:
```bash
ssh cool-lemur-ab12cd
```

---

## 4) Connect with JetBrains Gateway

1. Open JetBrains Gateway
2. Select “Connect via SSH”
3. In the Host field, enter the alias from your `~/.ssh/config`, for example:
   ```bash
   cool-lemur-ab12cd
   ```
4. The User field is usually not needed (it is already defined in config as `codespace`)
5. Proceed: Gateway will connect and install the IDE backend on the Codespace
6. Choose the JetBrains IDE to use (IntelliJ, WebStorm, etc.)

---

## 5) Important Notes

- Codespaces endpoints can change after suspension/resumption. In that case, regenerate the file:
  ```bash
  gh codespace ssh --config > ~/.ssh/codespaces
  ```
  (You do not need to re-edit `~/.ssh/config` if you have already added the `Include` line.)

- Recommended automation: run the command above before opening Gateway, or create a script/alias that updates the configuration and then launches Gateway.

Need a Bash script to do everything in one go? I can prepare it.
