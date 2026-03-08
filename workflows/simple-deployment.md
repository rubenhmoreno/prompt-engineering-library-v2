# Simple Deployment Workflow

> **Executive Summary:** Step-by-step guide for moving an application from a development machine to a production server, designed for non-programmers. Three methods from simplest to most automated, with copy-paste commands and plain-language explanations. No Docker, no Kubernetes, no complex tooling.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [devops-engineer](../agents/devops-engineer.md), [verification-protocol](verification-protocol.md), [error-prevention](../core/error-prevention.md) |

---

## Quick Reference Card

### Which Method Should I Use?

| Method | Difficulty | Best For | Time to Set Up |
|--------|-----------|----------|---------------|
| 1. Manual copy | Easiest | First-time deployment, one-off updates | 5 minutes |
| 2. Git pull | Easy | Regular updates, team collaboration | 15 minutes (once) |
| 3. Auto-deploy | Medium | Frequent updates, zero-touch deploys | 30 minutes (once) |

### Decision Tree

```
Is this your first time deploying?
|
+-- Yes --> Method 1 (Manual Copy)
|
+-- No, I already have the project on the server
    |
    +-- I update once a week or less --> Method 2 (Git Pull)
    |
    +-- I update multiple times per day --> Method 3 (Auto-Deploy)
```

### Pre-Deployment Checklist

Before deploying with any method, verify these on your development machine:

- [ ] The application works correctly on your local machine
- [ ] You have tested the main features (login, forms, pages)
- [ ] You know the server IP address and login credentials
- [ ] You know where the application should live on the server

---

## Full Content

### Prerequisites

**On your development machine, you need:**
- A terminal (Command Prompt on Windows, Terminal on Mac/Linux)
- SSH access to your server (your hosting provider gives you this)

**On your production server, you need:**
- The programming language your app uses (PHP, Python, Node.js, etc.)
- A web server (Apache or Nginx — most hosting providers include this)

If you are unsure about any prerequisite, ask your hosting provider. They can confirm what is already installed.

---

### Method 1: Manual Copy (Simplest)

Use this when you want to put your application on the server for the first time or when you make occasional updates.

**What this does:** Copies all your project files from your computer to the server.

#### Step 1: Connect to your server

Open a terminal and type:
```bash
ssh your-username@your-server-ip
```
Replace `your-username` with the username your hosting provider gave you, and `your-server-ip` with the server's IP address (looks like `192.168.1.100` or `myserver.example.com`).

It will ask for your password. Type it (you will not see characters appearing — that is normal) and press Enter.

#### Step 2: Create a folder for your application

Once connected to the server:
```bash
mkdir -p /var/www/my-application
```
Replace `my-application` with your project name (no spaces, use dashes instead).

Type `exit` to disconnect from the server.

#### Step 3: Copy your files to the server

From your development machine, navigate to your project folder and run:
```bash
scp -r ./* your-username@your-server-ip:/var/www/my-application/
```

This copies everything in your current folder to the server. Wait for it to finish — it shows progress for each file.

#### Step 4: Verify it worked

Connect to the server again and check:
```bash
ssh your-username@your-server-ip
ls /var/www/my-application/
```
You should see your project files listed.

#### Step 5: Start the application

Depending on your technology:

| Technology | Start Command |
|-----------|--------------|
| PHP | `php -S 0.0.0.0:8080` (for testing) or configure Apache (for production) |
| Python | `python3 app.py` or `gunicorn app:app --bind 0.0.0.0:8080` |
| Node.js | `node app.js` or `npm start` |

#### Step 6: Check it works

Open a web browser and go to: `http://your-server-ip:8080`

You should see your application running.

#### Updating later

When you make changes, repeat Step 3. The `scp` command will overwrite the old files with the new ones.

**Important:** If your application uses a database file (like SQLite), be careful not to overwrite the production database with your development one. Exclude it:
```bash
scp -r $(ls -d ./* | grep -v database.sqlite) your-username@your-server-ip:/var/www/my-application/
```

---

### Method 2: Git Pull (Regular Updates)

Use this when you update your application regularly and want a cleaner process. Requires a GitHub (or similar) account.

**What this does:** Your code lives on GitHub. To update the server, you just tell it to download the latest version.

#### One-Time Setup

**On your development machine:**

1. If your project is not yet on GitHub, push it:
```bash
cd your-project-folder
git init
git add -A
git commit -m "Initial version"
git remote add origin https://github.com/your-username/your-project.git
git push -u origin main
```

**On your server (connect via SSH first):**

2. Clone the project:
```bash
cd /var/www
git clone https://github.com/your-username/your-project.git my-application
```

3. Start the application (same as Method 1, Step 5).

#### Updating (Every Time You Make Changes)

**On your development machine:**
```bash
git add -A
git commit -m "Describe what you changed"
git push
```

**On your server:**
```bash
ssh your-username@your-server-ip
cd /var/www/my-application
git pull
```

That is it. The server now has your latest code.

If the application needs to be restarted after the update:

| Technology | Restart Command |
|-----------|----------------|
| PHP (Apache) | `sudo systemctl restart apache2` |
| Python (gunicorn) | `sudo systemctl restart my-application` |
| Node.js (PM2) | `pm2 restart my-application` |

---

### Method 3: Auto-Deploy (Push and Forget)

Use this when you want the server to update automatically every time you push to GitHub. After the one-time setup, you never SSH into the server again for deployments.

**What this does:** GitHub detects your push, connects to your server, and runs the update commands for you.

#### One-Time Setup

1. Complete Method 2 setup first (your project must be on GitHub and cloned on the server).

2. Create a deploy script on your server:
```bash
ssh your-username@your-server-ip
cat > /var/www/my-application/deploy.sh << 'SCRIPT'
#!/bin/bash
cd /var/www/my-application
git pull origin main

# Restart the application (uncomment the line for your technology):
# sudo systemctl restart apache2          # PHP with Apache
# sudo systemctl restart my-application   # Python with systemd
# pm2 restart my-application              # Node.js with PM2

echo "Deploy completed at $(date)"
SCRIPT
chmod +x /var/www/my-application/deploy.sh
```

3. Create a GitHub Actions workflow in your project:
```bash
mkdir -p .github/workflows
```

Create the file `.github/workflows/deploy.yml`:
```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to server
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: /var/www/my-application/deploy.sh
```

4. Add your server credentials to GitHub:
   - Go to your repository on GitHub
   - Click **Settings** > **Secrets and variables** > **Actions**
   - Add these three secrets:
     - `SERVER_HOST`: your server IP address
     - `SERVER_USER`: your SSH username
     - `SSH_PRIVATE_KEY`: your SSH private key (the content of `~/.ssh/id_rsa`)

5. Push the workflow file:
```bash
git add -A
git commit -m "Add auto-deploy"
git push
```

From now on, every push to `main` triggers an automatic deployment.

#### Checking if the Deploy Worked

- Go to your repository on GitHub
- Click the **Actions** tab
- You should see a green checkmark next to your latest push

If it shows a red X, click on it to see what went wrong.

---

### Something Went Wrong?

| Problem | Solution |
|---------|----------|
| `Permission denied` when using SSH | Check that your username and password are correct. Ask your hosting provider to verify SSH access is enabled |
| `Connection refused` on port 8080 | The application is not running. Connect via SSH and start it again (Method 1, Step 5) |
| Files copied but website shows old version | Clear your browser cache (Ctrl+Shift+R) or try a different browser |
| `git pull` shows conflicts | Your server files were modified directly. Run `git checkout -- .` to discard server changes, then `git pull` again |
| Database errors after deploy | You may have overwritten the production database. Restore from backup if available |
| Auto-deploy not triggering | Check GitHub Actions tab for errors. Verify the secrets are set correctly |
| Website works on server IP but not on domain name | DNS needs to be configured. Ask your hosting provider to point your domain to the server IP |

### Rolling Back (Undoing a Bad Deploy)

If an update broke something and you need to go back to the previous version:

```bash
ssh your-username@your-server-ip
cd /var/www/my-application
git log --oneline -5
```

This shows the last 5 versions. Find the one that worked (before your bad change) and note its code (like `a1b2c3d`).

```bash
git checkout a1b2c3d -- .
```

Your application is now back to the previous version. Restart the application if needed.

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Editing files directly on the production server | Always edit on your development machine, then deploy | Direct edits get lost on the next deploy and cannot be tracked |
| Overwriting the production database with the development one | Exclude database files from deployment | Production data is irreplaceable; development data is test data |
| Deploying without testing locally first | Always verify the application works on your machine before deploying | Deploying broken code takes down the live application |
| Sharing SSH passwords in chat or email | Use SSH keys instead of passwords when possible | Passwords in messages can be intercepted |
| Deploying on Friday afternoon | Deploy early in the week when you have time to fix issues | Weekend deploys with no one available to fix problems cause extended outages |
| Skipping the "does it work" check after deploy | Always open the application in a browser after deploying | Deployment can succeed but the application can still be broken |

---

## Related Documents

- [agents/devops-engineer.md](../agents/devops-engineer.md) — Advanced deployment (Docker, Kubernetes, CI/CD pipelines)
- [workflows/verification-protocol.md](verification-protocol.md) — How to verify that a deployment actually worked
- [core/error-prevention.md](../core/error-prevention.md) — Preventing common errors before they reach production
- [quick-ref/command-reference.md](../quick-ref/command-reference.md) — All verification commands in one place

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
