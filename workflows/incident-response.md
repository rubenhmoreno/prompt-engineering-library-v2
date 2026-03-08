# Incident Response Workflow
> **Executive Summary:** A structured, time-boxed procedure for detecting, containing, resolving, and learning from production incidents. Every phase has a responsible agent, a maximum time budget, and a mandatory output. Without time-boxing, incidents expand to fill all available time; without postmortems, the same incident recurs. Follow this workflow for every service degradation, outage, or data integrity event.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [verification-protocol.md](verification-protocol.md), [evidence-report.md](../templates/evidence-report.md), [agent-handoff.md](../templates/agent-handoff.md) |

---

## Quick Reference Card

### Severity Levels

| Severity | Definition | Acknowledgment SLA | Response Mode | Communication Cadence |
|----------|------------|-------------------|---------------|----------------------|
| P0 | Full outage — service completely unavailable or data loss in progress | 15 minutes | All-hands; drop everything | Every 15 minutes |
| P1 | Severe degradation — core feature broken for all or most users | 30 minutes | Dedicated responder(s) | Every 15 minutes |
| P2 | Partial degradation — non-critical feature broken or intermittent errors | 2 hours | Scheduled response | Every 2 hours |
| P3 | Minor issue — cosmetic bug, single-user report, not reproducible at scale | Next sprint | Backlog | None during incident |

### Five-Phase Timeline

| Phase | Responsible Agent | Time Budget | Output |
|-------|------------------|-------------|--------|
| 1 — TRIAGE | data-detective | 30 min max | Severity classification + blast radius |
| 2 — MITIGATE | backend-developer | 60 min max | Service restored (hotfix or rollback) |
| 3 — VERIFY | testing-engineer | 30 min max | Regression test results + monitoring confirmation |
| 4 — DEPLOY | devops-engineer | 30 min max | Fix deployed to production + health check passed |
| 5 — POSTMORTEM | all agents | 60 min max | Blameless root cause analysis + action items |

Total maximum time for P0: 3.5 hours from first alert to postmortem complete.

### Escalation Triggers

| Condition | Action |
|-----------|--------|
| Triage phase exceeds 30 minutes | Escalate P1 to P0; bring in all agents |
| Mitigation phase exceeds 60 minutes without a rollback option | Escalate; initiate rollback immediately |
| Verification finds new failures not in original blast radius | Return to TRIAGE with updated severity |
| Deploy phase finds production behaves differently from staging | Rollback; open a new incident for the environment divergence |

---

## Full Content

### Phase 1: TRIAGE

**Responsible agent:** data-detective
**Time budget:** 30 minutes maximum
**Clock starts:** at first alert or user report

**Goal:** Establish what is broken, how many users are affected, and what severity level applies. Do not attempt a fix during triage.

**Step-by-step:**

```
1. Reproduce the failure in a controlled environment (staging or local if possible)
   Command: [whatever verifies the failure — curl, logs, DB query]

2. Check error rate and affected scope
   - How many users are affected? All, some, one?
   - Which endpoints or features are failing?
   - Is data integrity at risk (P0 candidate)?

3. Examine application logs for the first occurrence
   journalctl -u myapp --since "30 minutes ago" | grep -E "ERROR|CRITICAL|Exception"
   docker logs myapp --since 30m 2>&1 | grep -iE "error|fatal"

4. Check infrastructure health
   systemctl status myapp
   docker ps
   df -h          # disk full?
   free -m        # memory pressure?
   uptime         # CPU load?

5. Check recent deployments
   git log --oneline -10
   # Was there a deploy in the last hour?

6. Classify severity using the table above
```

**Output — Triage Report:**

```
=== TRIAGE REPORT ===
Time:               [HH:MM UTC]
Reporter:           data-detective
Severity:           [P0 / P1 / P2 / P3]

Symptom:            [one sentence — what is broken]
First occurrence:   [timestamp from logs]
Blast radius:       [who is affected and what they cannot do]
Data integrity:     [at risk / not at risk]
Recent deploy:      [yes — commit SHA and time / no]
Root cause hypothesis: [best guess — to be confirmed in postmortem]

Immediate risk:     [what gets worse if we wait]
Recommended action: [hotfix / rollback / monitor]
=== END TRIAGE REPORT ===
```

Broadcast the Triage Report to all stakeholders immediately. For P0/P1, send a status update every 15 minutes until the incident is resolved.

---

### Phase 2: MITIGATE

**Responsible agent:** backend-developer
**Time budget:** 60 minutes maximum
**Input:** Triage Report from Phase 1

**Goal:** Restore service as fast as possible. The fastest path is almost always a rollback. A hotfix is only appropriate when rollback is not possible or would cause more harm than the incident itself.

**Decision tree:**

```
Was there a recent deploy?
  YES -> Can we rollback safely?
           YES -> ROLLBACK FIRST (takes 5-10 min vs 60 min for a hotfix)
           NO  -> Why not? Document the reason. Proceed to hotfix.
  NO  -> Hotfix is the only path. Identify the root cause and fix it.
```

**Rollback procedure:**

```bash
# Identify the last good commit
git log --oneline -20

# Tag the bad commit for postmortem reference
git tag incident-2026-03-08-p0 HEAD

# Roll back the application
git checkout <last-good-sha>

# Redeploy (adapt to your deployment method)
docker build -t myapp:rollback .
docker stop myapp && docker run -d --name myapp myapp:rollback

# Confirm the service is up
curl -f http://localhost:8000/health
# Expected: {"status": "ok"}
```

**Hotfix procedure (when rollback is not viable):**

```
1. Reproduce in isolation — never debug blind in production
2. Write a failing test that captures the bug (TDD discipline, even under pressure)
3. Implement the minimum fix to make the test pass
4. Run the full test suite — do not skip
5. Generate a diff and have a second agent review it before deploying
```

**Output — Mitigation Report:**

```
=== MITIGATION REPORT ===
Time:               [HH:MM UTC]
Agent:              backend-developer
Action taken:       [rollback to SHA / hotfix — description]

Service status:     [restored / partially restored / not yet restored]
Evidence:
  curl output:      [paste actual output]
  service status:   [paste systemctl or docker ps output]

Users affected now: [count or "none — service restored"]
Time spent:         [N minutes]
Remaining risk:     [any lingering issues?]
=== END MITIGATION REPORT ===
```

If 60 minutes pass without a clear path to resolution, escalate the severity and consider calling in additional agents. Do not continue debugging indefinitely without a rollback fallback.

---

### Phase 3: VERIFY

**Responsible agent:** testing-engineer
**Time budget:** 30 minutes maximum
**Input:** Mitigation Report from Phase 2

**Goal:** Confirm that the fix or rollback actually resolved the incident and did not introduce new failures. Verify with real command output, not visual inspection.

**Step-by-step:**

```bash
# 1. Run the regression test suite
pytest tests/ -v --cov=src --cov-report=term-missing
# Required: all tests PASSED; coverage >= 80%

# 2. Exercise the endpoints that were reported broken in the Triage Report
curl -i [endpoint that was failing]
# Required: correct HTTP status + expected response body

# 3. Verify monitoring metrics are back to baseline
# - Error rate should be near 0
# - Response time should be within normal range
# - No new ERROR lines appearing in logs

# 4. Check that the fix does not affect adjacent functionality
# Run tests for the modules that interact with the fixed code

# 5. Confirm data integrity if it was at risk
psql -c "SELECT COUNT(*), MIN(created_at) FROM affected_table WHERE condition;"
```

**Output — Verification Report:**

```
=== VERIFICATION REPORT ===
Time:               [HH:MM UTC]
Agent:              testing-engineer
Test run:           [N passed, 0 failed]
Coverage:           [N%]

Endpoints verified:
  [endpoint 1]:     [HTTP status] — [pass / fail]
  [endpoint 2]:     [HTTP status] — [pass / fail]

Monitoring:
  Error rate:       [current value vs baseline]
  Response time p95:[current value vs baseline]

Data integrity:     [confirmed / still at risk — see notes]
New issues found:   [none / list]

Verdict:            [RESOLVED / PARTIAL / UNRESOLVED — escalate]
=== END VERIFICATION REPORT ===
```

If the verdict is PARTIAL or UNRESOLVED, return to Phase 2 with a detailed description of what verification revealed.

---

### Phase 4: DEPLOY

**Responsible agent:** devops-engineer
**Time budget:** 30 minutes maximum
**Input:** Verification Report from Phase 3 (must show RESOLVED)

**Goal:** Deploy the verified fix to the production environment and confirm that production behaves identically to the verified environment.

**Step-by-step:**

```bash
# 1. Tag the fix commit
git tag fix-incident-2026-03-08-p0 HEAD
git push origin fix-incident-2026-03-08-p0

# 2. Deploy using the standard pipeline (do not bypass CI)
# GitHub Actions / GitLab CI / deployment script — use the normal path
# Bypassing CI introduces risk at exactly the moment you can least afford it

# 3. Monitor the deployment progress
# Watch logs in real time during rollout
journalctl -u myapp -f

# 4. Run the health check immediately after deploy
curl -f https://example.com/health
# Expected: {"status": "ok", "version": "[new version]"}

# 5. Confirm error rate in production monitoring
# Check the same metrics verified in Phase 3 — they must match

# 6. Perform a smoke test on the endpoint that was failing
curl -i https://example.com/[affected-endpoint]
# Expected: same result as Phase 3 verification
```

**Output — Deploy Report:**

```
=== DEPLOY REPORT ===
Time:               [HH:MM UTC]
Agent:              devops-engineer
Deployed:           [commit SHA or image tag]
Environment:        production

Health check:       [pass — output pasted]
Smoke test:         [pass — output pasted]
Error rate (prod):  [current value]
Response time (prod): [current p95 value]

Status:             [DEPLOYED AND HEALTHY / DEPLOYED WITH ISSUES]
=== END DEPLOY REPORT ===
```

If production behaves differently from the verified environment, initiate a rollback immediately and open a new incident for the environment divergence. Do not continue investigating in production.

---

### Phase 5: POSTMORTEM

**Responsible agents:** all agents involved in the incident
**Time budget:** 60 minutes maximum
**Input:** All four previous phase reports

**Goal:** Identify the true root cause (not just the proximate cause), produce concrete action items that prevent recurrence, and do so without assigning blame to individuals.

**Blameless postmortem principles:**
- People acted rationally given the information and tools they had at the time
- The goal is to improve systems and processes, not to find fault
- Every postmortem produces action items; postmortems without action items are not complete

**Root cause analysis — Five Whys:**

```
Symptom:    [from Triage Report]
Why 1:      [immediate technical cause]
Why 2:      [what allowed why 1 to occur]
Why 3:      [what allowed why 2 to occur]
Why 4:      [what process or system gap allowed why 3]
Why 5:      [what structural condition allowed why 4]

Root cause: [statement at the systemic level — the answer to Why 5]
```

**Output — Postmortem Report:**

```
=== POSTMORTEM REPORT ===
Incident ID:        INC-2026-03-08-001
Severity:           [P0 / P1 / P2]
Duration:           [HH:MM from first alert to DEPLOY COMPLETE]
Date:               2026-03-08

--- TIMELINE ---
[HH:MM] First alert / user report
[HH:MM] Triage complete — P[N] declared
[HH:MM] Mitigation started
[HH:MM] Service restored (rollback or hotfix)
[HH:MM] Verification passed
[HH:MM] Production deploy complete
[HH:MM] Postmortem complete

--- IMPACT ---
Users affected:     [count or percentage]
Duration of impact: [N minutes]
Data loss:          [yes / no — if yes, describe]

--- ROOT CAUSE ---
Proximate cause:    [the immediate technical trigger]
Root cause:         [the systemic condition — from Five Whys]

--- FIVE WHYS ---
Why 1: [...]
Why 2: [...]
Why 3: [...]
Why 4: [...]
Why 5: [...]

--- WHAT WENT WELL ---
- [list things that limited the impact or sped up resolution]

--- WHAT WENT POORLY ---
- [list things that slowed resolution or made the impact worse]

--- ACTION ITEMS ---
| # | Action | Owner | Due date | Priority |
|---|--------|-------|----------|----------|
| 1 | [specific, verifiable action] | [agent or team] | [date] | P[N] |
| 2 | ... | ... | ... | ... |

--- LESSONS LEARNED ---
[One paragraph summarizing what the team now knows that they did not know before]
=== END POSTMORTEM ===
```

Every action item must be specific enough to verify completion. "Improve monitoring" is not an action item. "Add an alert that fires when error rate exceeds 1% for 2 consecutive minutes" is an action item.

---

### Communication Cadence

For P0 and P1 incidents, send a status update to all stakeholders every 15 minutes regardless of progress. Use this template:

```
[HH:MM UTC] INCIDENT UPDATE — [P0/P1] [short description]
Status:   [investigating / mitigating / verifying / resolved]
Impact:   [current blast radius]
ETA:      [best estimate to resolution, or "unknown"]
Next update: [HH:MM UTC]
```

For P2, update every 2 hours. For P3, update when the fix is in the backlog and again when it ships.

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Start debugging in production before attempting to reproduce in staging | Reproduce in isolation first; only access production logs and metrics, not the running code | Changes made blindly in production during an incident are themselves a source of new incidents |
| Skip the rollback option because "we can fix it faster" | Always evaluate rollback before hotfix; rollback is almost always faster | A hotfix under time pressure is more likely to introduce a second bug than a clean rollback |
| Skip the postmortem because "we're too busy" | Protect postmortem time; it is the only phase that prevents recurrence | Incidents without postmortems recur; the time "saved" by skipping is spent again on the next incident |
| Exceed the time box for a phase without escalating | When a time box is reached, escalate severity and bring in more agents | Continuing past a time box alone rarely succeeds and always delays resolution |
| Assign blame in the postmortem | Focus on system and process improvements | Blame prevents honest reporting and does not fix the system that allowed the failure |
| Use "human error" as the root cause | Dig to the systemic condition that made the error easy to make | If a human made an error, the system made that error easy; fix the system |
| Send a single update at the start and nothing until resolution | Maintain the communication cadence throughout | Silence during an incident causes stakeholders to escalate in parallel, creating noise that slows resolution |

---

## Related Documents

- [verification-protocol.md](verification-protocol.md) — Evidence standards applied in Phase 3 (Verify) and Phase 4 (Deploy)
- [evidence-report.md](../templates/evidence-report.md) — Template for documenting the resolution evidence
- [agent-handoff.md](../templates/agent-handoff.md) — How to hand off the incident between agents across phases
- [tdd-workflow.md](tdd-workflow.md) — TDD discipline to apply when writing a hotfix under pressure

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
