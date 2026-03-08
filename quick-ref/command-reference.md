# Command Reference

> **Executive Summary:** Categorized reference for all verification commands used in the library's Verification Protocol. Every claim about system state must be backed by one of these commands and its actual output. Organized by category so you can find the right command in under 10 seconds.

| Metadata | Value |
|----------|-------|
| Type     | Reference |
| Version  | 2.0.0 |
| Updated  | 2026-03-08 |
| Related  | [Verification Protocol](../workflows/verification-protocol.md), [Workflow Decision Tree](workflow-decision-tree.md) |

---

## Core Principle

Never assert — prove. Before claiming anything about system state, run the appropriate command and include the output as evidence.

```
WRONG: "The database is running."
RIGHT: $ systemctl is-active postgresql
       active
```

---

## File System

| Command | Purpose | Example |
|---------|---------|---------|
| `ls -lh /path/` | List files with sizes and permissions | `ls -lh /opt/myapp/` |
| `ls -la /path/` | List all files including hidden | `ls -la ~/.ssh/` |
| `test -f /path && echo exists` | Check if regular file exists | `test -f /etc/app.conf && echo exists` |
| `test -d /path && echo exists` | Check if directory exists | `test -d /var/log/myapp && echo exists` |
| `find /path -name "pattern"` | Search files by name pattern | `find /opt -name "*.py" -type f` |
| `find /path -mtime -1` | Files modified in last 24 hours | `find /var/log -name "*.log" -mtime -1` |
| `wc -l /path/to/file` | Count lines in file | `wc -l /opt/myapp/requirements.txt` |
| `file /path/to/file` | Identify file type and encoding | `file Install.ps1` |
| `du -sh /path/` | Show directory size | `du -sh /opt/myapp/` |
| `stat /path/to/file` | Show detailed file metadata | `stat /etc/app.conf` |

---

## Processes and Services

| Command | Purpose | Example |
|---------|---------|---------|
| `ps aux \| grep process_name` | Find running process by name | `ps aux \| grep python3` |
| `pgrep -f "pattern"` | Find process by full command match | `pgrep -f "uvicorn main:app"` |
| `systemctl is-active service` | Check if systemd service is active | `systemctl is-active postgresql` |
| `systemctl status service` | Full status of systemd service | `systemctl status nginx` |
| `systemctl list-units --failed` | List all failed services | `systemctl list-units --failed` |
| `journalctl -u service -n 50` | Last 50 log lines for a service | `journalctl -u myapp.service -n 50` |
| `journalctl -u service -f` | Follow live log output | `journalctl -u myapp.service -f` |
| `netstat -tulpn \| grep :PORT` | Check what is listening on a port | `netstat -tulpn \| grep :8000` |
| `ss -tulpn \| grep :PORT` | Same as netstat (modern alternative) | `ss -tulpn \| grep :5432` |
| `lsof -i :PORT` | List processes using a port | `lsof -i :8000` |
| `kill -0 PID` | Check if process is alive (no signal sent) | `kill -0 12345 && echo "alive"` |

---

## Software and Versions

| Command | Purpose | Example |
|---------|---------|---------|
| `command -v tool` | Check if command exists in PATH | `command -v python3` |
| `which tool` | Show full path of command | `which uvicorn` |
| `tool --version` | Show tool version | `python3 --version` |
| `python3 --version` | Python version | `python3 --version` |
| `node --version` | Node.js version | `node --version` |
| `npm --version` | npm version | `npm --version` |
| `docker --version` | Docker version | `docker --version` |
| `dotnet --version` | .NET SDK/Runtime version | `dotnet --version` |
| `pip show package` | Show installed Python package info | `pip show fastapi` |
| `pip list \| grep package` | Check if Python package is installed | `pip list \| grep sqlmodel` |
| `npm list package --depth=0` | Check if npm package is installed | `npm list express --depth=0` |
| `dpkg -l \| grep package` | Check if Debian package is installed | `dpkg -l \| grep postgresql` |

---

## Database

### PostgreSQL

| Command | Purpose | Example |
|---------|---------|---------|
| `psql -U user -d db -c "SELECT 1"` | Test database connectivity | `psql -U admin -d mydb -c "SELECT 1"` |
| `psql -U user -d db -c "\dt"` | List all tables | `psql -U admin -d mydb -c "\dt"` |
| `psql -U user -d db -c "\d table"` | Describe table schema | `psql -U admin -d mydb -c "\d users"` |
| `psql -U user -d db -c "SELECT COUNT(*) FROM table"` | Count rows in table | `psql -U admin -d mydb -c "SELECT COUNT(*) FROM users"` |
| `psql -U user -d db -c "\l"` | List all databases | `psql -U postgres -c "\l"` |

### MySQL / MariaDB

| Command | Purpose | Example |
|---------|---------|---------|
| `mysql -u user -p -e "SELECT 1"` | Test connectivity | `mysql -u root -p -e "SELECT 1"` |
| `mysql -u user -p -e "SHOW TABLES"` | List tables | `mysql -u root -p mydb -e "SHOW TABLES"` |
| `mysql -u user -p -e "SHOW DATABASES"` | List databases | `mysql -u root -p -e "SHOW DATABASES"` |

### MongoDB

| Command | Purpose | Example |
|---------|---------|---------|
| `mongosh --eval "db.runCommand({ ping: 1 })"` | Test connectivity | `mongosh --eval "db.runCommand({ ping: 1 })"` |
| `mongosh mydb --eval "db.getCollectionNames()"` | List collections | `mongosh mydb --eval "db.getCollectionNames()"` |
| `mongosh mydb --eval "db.users.countDocuments()"` | Count documents | `mongosh mydb --eval "db.users.countDocuments()"` |

---

## Testing

| Command | Purpose | Example |
|---------|---------|---------|
| `pytest tests/ -v` | Run all tests with verbose output | `pytest tests/ -v` |
| `pytest tests/ --cov=app` | Run tests with coverage | `pytest tests/ --cov=app --cov-report=term` |
| `pytest tests/test_file.py::test_name` | Run a specific test | `pytest tests/test_users.py::test_create_user` |
| `pytest tests/ -x` | Stop on first failure | `pytest tests/ -x` |
| `pytest tests/ -k "keyword"` | Run tests matching keyword | `pytest tests/ -k "auth"` |
| `npm test` | Run Node.js test suite | `npm test` |
| `npm test -- --coverage` | Run with coverage | `npm test -- --coverage` |
| `dotnet test` | Run .NET test suite | `dotnet test MyApp.Tests/` |
| `go test ./...` | Run all Go tests | `go test ./...` |
| `coverage report --fail-under=80` | Enforce minimum coverage | `coverage report --fail-under=80` |

---

## Git

| Command | Purpose | Example |
|---------|---------|---------|
| `git status` | Show working tree state | `git status` |
| `git diff` | Show unstaged changes | `git diff` |
| `git diff --staged` | Show staged changes | `git diff --staged` |
| `git log --oneline -10` | Last 10 commits, one line each | `git log --oneline -10` |
| `git log --author="name" -5` | Last 5 commits by author | `git log --author="Alice" -5` |
| `git show HEAD` | Show most recent commit details | `git show HEAD` |
| `git branch -a` | List all branches | `git branch -a` |
| `git tag` | List all tags | `git tag` |
| `git stash list` | List stashed changes | `git stash list` |
| `git remote -v` | Show remote URLs | `git remote -v` |

---

## Docker

| Command | Purpose | Example |
|---------|---------|---------|
| `docker ps` | List running containers | `docker ps` |
| `docker ps -a` | List all containers including stopped | `docker ps -a` |
| `docker logs container_name` | View container logs | `docker logs myapp` |
| `docker logs -f container_name` | Follow live container logs | `docker logs -f myapp` |
| `docker exec -it container cmd` | Run command inside container | `docker exec -it myapp sh` |
| `docker inspect container_name` | Full container configuration | `docker inspect myapp` |
| `docker images` | List local images | `docker images` |
| `docker compose ps` | List compose services | `docker compose ps` |
| `docker compose logs service` | Logs for a compose service | `docker compose logs api` |
| `docker stats --no-stream` | Snapshot of resource usage | `docker stats --no-stream` |
| `docker volume ls` | List volumes | `docker volume ls` |

---

## Network

| Command | Purpose | Example |
|---------|---------|---------|
| `curl -sf http://host/health` | Test HTTP endpoint (fail silently) | `curl -sf http://localhost:8000/health` |
| `curl -I http://host/path` | Show response headers only | `curl -I http://localhost:8000/api/users` |
| `curl -X POST -H "Content-Type: application/json" -d '{...}' url` | POST JSON payload | `curl -X POST -H "Content-Type: application/json" -d '{"email":"a@b.com"}' http://localhost:8000/api/users` |
| `wget -q --spider http://host/path` | Check URL is reachable | `wget -q --spider http://localhost:8000/health` |
| `ping -c 3 hostname` | Test ICMP reachability | `ping -c 3 api.example.com` |
| `dig hostname` | DNS lookup with details | `dig api.example.com` |
| `nslookup hostname` | Simple DNS lookup | `nslookup api.example.com` |
| `traceroute hostname` | Show network path to host | `traceroute api.example.com` |
| `nc -zv host port` | Test TCP port reachability | `nc -zv localhost 5432` |
| `openssl s_client -connect host:443` | Test TLS certificate | `openssl s_client -connect api.example.com:443` |

---

## Quick Copy-Paste Templates

### Health Check Script

```bash
# Verify service is up and responding
systemctl is-active myservice && \
  curl -sf http://localhost:8000/health && \
  echo "All checks passed"
```

### Pre-Deployment Verification

```bash
# Run before any deployment
git status            # Clean working tree
pytest tests/ -v      # All tests pass
docker compose ps     # Services healthy
```

### Post-Deployment Verification

```bash
# Run after any deployment
systemctl is-active myservice
curl -sf http://localhost:8000/health
journalctl -u myservice -n 20
```

---

## Related Documents

- [Verification Protocol](../workflows/verification-protocol.md) - How to use these commands as evidence
- [Workflow Decision Tree](workflow-decision-tree.md) - When to use which workflow
- [Best Practices Learned](../examples/best-practices-learned.md) - Real-world command usage examples
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
