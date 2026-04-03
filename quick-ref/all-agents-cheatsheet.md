# All Agents Cheatsheet

> **Executive Summary:** Single-page reference for all 19 specialized agents in the library. Use the table to identify the right agent for your task and the decision tree to break ties. Each agent link leads to full documentation with examples and anti-patterns.

| Metadata | Value |
|----------|-------|
| Type     | Reference |
| Version  | 2.1.0 |
| Updated  | 2026-03-08 |
| Related  | [Workflow Decision Tree](workflow-decision-tree.md), [Template Selector](template-selector.md) |

---

## Agent Quick Reference Table

| Agent | Domain | Use When | Key Output | Primary Tools | Link |
|-------|--------|----------|------------|---------------|------|
| **backend-developer** | APIs, databases, business logic, server infrastructure | Building REST/GraphQL APIs, data models, auth systems, background jobs | Functional endpoints, DB schemas, service layer code | FastAPI, SQLModel, PostgreSQL, pytest | [agents/backend-developer.md](../agents/backend-developer.md) |
| **frontend-developer** | UI rendering, state management, browser APIs, UX | Building web interfaces, forms, dashboards, client-side logic | HTML/CSS/JS, component trees, API integration | Vanilla JS, React/Vue, CSS, browser DevTools | [agents/frontend-developer.md](../agents/frontend-developer.md) |
| **testing-engineer** | Test strategy, coverage, automation, quality gates | Writing unit/integration/e2e tests, setting up CI test pipelines, auditing coverage | Test suites, coverage reports, test plans | pytest, Jest, Playwright, coverage.py | [agents/testing-engineer.md](../agents/testing-engineer.md) |
| **devops-engineer** | CI/CD, deployment pipelines, infrastructure automation, monitoring | Automating deployments, managing environments, configuring pipelines | Deploy scripts, pipeline configs, runbooks | GitHub Actions, Docker, systemd, Ansible | [agents/devops-engineer.md](../agents/devops-engineer.md) |
| **data-analyst** | Data processing, reporting, visualization, statistical analysis | Analyzing datasets, building reports, creating dashboards, ETL pipelines | Notebooks, reports, charts, cleaned datasets | pandas, SQL, Jupyter, matplotlib/plotly | [agents/data-analyst.md](../agents/data-analyst.md) |
| **data-detective** | Anomaly detection, root cause analysis, log investigation, forensics | Diagnosing production issues, finding data inconsistencies, investigating bugs | Root cause report, evidence trail, fix recommendations | grep/jq, SQL queries, log analysis tools | [agents/data-detective.md](../agents/data-detective.md) |
| **ui-ux-specialist** | Interface design, accessibility, user flows, design systems | Designing user experiences before implementation, accessibility audits, UX reviews | Wireframes, component specs, design tokens, A11y reports | Figma, WCAG guidelines, user flow diagrams | [agents/ui-ux-specialist.md](../agents/ui-ux-specialist.md) |
| **security-auditor** | Vulnerability assessment, threat modeling, compliance, secrets management | Security reviews, pen-test prep, dependency audits, OWASP compliance | Vulnerability report, risk matrix, remediation plan | OWASP tools, Bandit, Trivy, dependency scanners | [agents/security-auditor.md](../agents/security-auditor.md) |
| **api-architect** | API design, versioning strategy, contract-first design, documentation | Designing new APIs or overhauling existing ones before coding begins | OpenAPI spec, API style guide, versioning plan | OpenAPI/Swagger, Postman, API design principles | [agents/api-architect.md](../agents/api-architect.md) |
| **performance-engineer** | Profiling, bottleneck analysis, caching, query optimization | Diagnosing slow responses, reducing resource usage, setting performance budgets | Profiling report, optimized code, benchmark results | cProfile, k6, pg_explain, Redis, CDN configs | [agents/performance-engineer.md](../agents/performance-engineer.md) |
| **cloud-infrastructure** | Cloud resources, IaC, Kubernetes, networking, cost management | Provisioning infrastructure, managing K8s clusters, writing Terraform/Helm | IaC templates, network diagrams, cost estimates | Terraform, Helm, kubectl, AWS/GCP/Azure CLIs | [agents/cloud-infrastructure.md](../agents/cloud-infrastructure.md) |
| **debugger** | Runtime errors, stack traces, systematic debugging | Crashes, intermittent failures, error reproduction, stack trace analysis | Root cause analysis, fix recommendation, regression test | pdb, node --inspect, gdb, logging tools | [agents/debugger.md](../agents/debugger.md) |
| **git-workflow-manager** | Branch strategy, commits, PRs, conflict resolution | Setting up git workflow, managing releases, resolving merge conflicts | Branch strategy doc, commit conventions, PR templates | git, gh CLI, conventional commits | [agents/git-workflow-manager.md](../agents/git-workflow-manager.md) |
| **database-architect** | Schema design, migrations, query optimization, indexing | Designing schemas, planning migrations, optimizing slow queries | Migration files, index recommendations, schema docs | PostgreSQL, EXPLAIN ANALYZE, PgBouncer | [agents/database-architect.md](../agents/database-architect.md) |
| **technical-writer** | API docs, ADRs, runbooks, changelogs | Post-implementation documentation, operational runbooks, decision records | API reference, ADRs, runbooks, changelogs | OpenAPI, MkDocs, Sphinx, JSDoc | [agents/technical-writer.md](../agents/technical-writer.md) |
| **ui-ux-pro-max** | Industry-specific design, visual styles, navigation, animation, charts | New page design, choosing color/font/style by product category, mobile-native UI | Design system, style selection, navigation patterns, landing page patterns | Phosphor Icons, design reasoning rules, chart selection | [agents/ui-ux-pro-max.md](../agents/ui-ux-pro-max.md) |
| **pentester-auditor** | Penetration testing, OSINT, vulnerability assessment, infrastructure audit | Active security testing, vulnerability discovery, attack surface mapping, compliance audits | Vulnerability report, CVSS-scored findings, kill chain analysis, remediation plan | Nmap, Nuclei, ffuf, SQLMap, testssl.sh, Trivy, trufflehog | [agents/pentester-auditor.md](../agents/pentester-auditor.md) |
| **blue-team-engineer** | Defensive security, SOC operations, hardening, incident response, zero-trust | Firewall config, server hardening, incident response, SIEM setup, monitoring, backup/DR | Hardening plan, firewall rules, IDS config, incident playbooks, compliance report | ufw/iptables, Suricata, Wazuh, Fail2ban, Lynis, AIDE, WireGuard | [agents/blue-team-engineer.md](../agents/blue-team-engineer.md) |
| **red-team-researcher** | Threat intelligence, adversary emulation, red team design, strategic risk | Threat modeling, red team exercise design, TTP analysis, executive risk reports | Threat model, attack scenarios, ATT&CK mapping, executive risk assessment | STRIDE, PASTA, MITRE ATT&CK, Kill Chain analysis | [agents/red-team-researcher.md](../agents/red-team-researcher.md) |

---

## Agent Selection Guide

Use this decision tree when you are not sure which agent to activate.

```
What is the primary goal?
|
+-- Writing server-side code (APIs, services, DB)?
|       --> backend-developer
|
+-- Building a user interface (pages, components, forms)?
|       --> frontend-developer
|
+-- Writing, fixing, or auditing tests?
|       --> testing-engineer
|
+-- Deploying, pipelines, environments, automation?
|       --> devops-engineer
|
+-- Analyzing or transforming data, building reports?
|       --> data-analyst
|
+-- Investigating a bug, anomaly, or production incident?
|       --> data-detective
|
+-- Designing the user experience or interface before coding?
|       --> ui-ux-specialist
|
+-- Security review, vulnerability scan, threat modeling?
|       --> security-auditor
|
+-- Designing an API contract (before implementation)?
|       --> api-architect
|
+-- Profiling performance, fixing slow code or queries?
|       --> performance-engineer
|
+-- Provisioning cloud resources, Kubernetes, IaC?
|       --> cloud-infrastructure
|
+-- Debugging a runtime error, crash, or intermittent failure?
|       --> debugger
|
+-- Setting up git workflow, branches, or resolving conflicts?
|       --> git-workflow-manager
|
+-- Designing database schema, optimizing queries, planning migrations?
|       --> database-architect
|
+-- Writing documentation, ADRs, runbooks, or changelogs?
|       --> technical-writer
|
+-- Choosing design style, colors, fonts by product category? Mobile UI?
|       --> ui-ux-pro-max
|
+-- Penetration testing, vulnerability scanning, OSINT, attack surface mapping?
|       --> pentester-auditor
|
+-- Hardening servers, configuring firewalls, incident response, SIEM setup?
|       --> blue-team-engineer
|
+-- Threat modeling, red team exercise design, adversary emulation, executive risk?
        --> red-team-researcher
```

### Overlap Resolution

Some tasks sit at the boundary between agents. Use these rules:

| Situation | Primary Agent | Supporting Agent |
|-----------|---------------|-----------------|
| API design + implementation | api-architect (design first) | backend-developer (implement after) |
| Security-sensitive backend code | backend-developer | security-auditor (review after) |
| Penetration test with remediation | pentester-auditor (find vulns) | blue-team-engineer (remediate) |
| Threat modeling + red team exercise | red-team-researcher (strategy) | pentester-auditor (execute) |
| Full security audit (all phases) | pentester-auditor + security-auditor | blue-team-engineer + red-team-researcher |
| Incident response with forensics | blue-team-engineer (respond) | pentester-auditor (investigate vector) |
| Frontend performance problems | performance-engineer | frontend-developer (apply fixes) |
| Cloud deployment with CI/CD | devops-engineer | cloud-infrastructure (if K8s/IaC involved) |
| Data bug in production | data-detective (diagnose) | data-analyst (fix pipeline) |
| UX design + accessibility | ui-ux-specialist | testing-engineer (a11y tests) |
| Runtime error in backend code | debugger (diagnose) | backend-developer (fix) |
| Database schema + API design | database-architect (schema first) | backend-developer (implement) |
| Slow database queries | database-architect (optimize) | performance-engineer (profile) |
| Post-feature documentation | technical-writer | api-architect (API docs review) |
| New product design (industry-specific) | ui-ux-pro-max (style/patterns) | ui-ux-specialist (WCAG/tokens) |
| Mobile app UI design | ui-ux-pro-max (mobile rules) | frontend-developer (implement) |

### Multi-Agent Activation

When a task clearly spans multiple domains, use the [Parallel Development workflow](../workflows/parallel-development.md) rather than picking one agent. Typical combinations:

- **Full-stack feature**: api-architect + backend-developer + frontend-developer + testing-engineer
- **Secure API**: api-architect + backend-developer + security-auditor
- **Production incident**: data-detective + performance-engineer + devops-engineer
- **Cloud-native deployment**: cloud-infrastructure + devops-engineer + security-auditor
- **Full security audit**: pentester-auditor + security-auditor + red-team-researcher + blue-team-engineer
- **Pentest + remediation**: pentester-auditor + blue-team-engineer
- **Threat assessment**: red-team-researcher + pentester-auditor

---

## Agent Capability Matrix

| Agent | Code | Design | Analysis | Ops | Security |
|-------|------|--------|----------|-----|----------|
| backend-developer | High | Low | Medium | Low | Medium |
| frontend-developer | High | Medium | Low | Low | Low |
| testing-engineer | High | Low | High | Medium | Medium |
| devops-engineer | Medium | Low | Medium | High | Medium |
| data-analyst | Medium | Low | High | Low | Low |
| data-detective | Low | Low | High | Medium | Low |
| ui-ux-specialist | Low | High | Medium | Low | Low |
| security-auditor | Medium | Low | High | Medium | High |
| api-architect | Medium | High | Medium | Low | Medium |
| performance-engineer | High | Low | High | Medium | Low |
| cloud-infrastructure | Medium | Medium | Low | High | Medium |
| debugger | Medium | Low | High | Low | Low |
| git-workflow-manager | Low | Low | Low | Medium | Low |
| database-architect | High | Medium | High | Low | Medium |
| technical-writer | Low | Medium | Low | Low | Low |
| ui-ux-pro-max | Low | High | Medium | Low | Low |
| pentester-auditor | Medium | Low | High | Medium | High |
| blue-team-engineer | Medium | Low | Medium | High | High |
| red-team-researcher | Low | Low | High | Low | High |

---

## Recommended Prompting Technique by Agent

Use the right technique to get the best output from each agent. See [core/prompting-techniques.md](../core/prompting-techniques.md) for full details.

| Agent | Primary Technique | When to Apply |
|-------|-------------------|---------------|
| backend-developer | Few-Shot | Consistent API patterns, CRUD generation |
| frontend-developer | Few-Shot | Component structure consistency |
| testing-engineer | Few-Shot + CoT | Test pattern reuse + edge case reasoning |
| devops-engineer | ReAct | Must verify infrastructure state before acting |
| data-analyst | CoT | Step-by-step data analysis reasoning |
| data-detective | ReAct + CoT | Investigate with evidence, reason about anomalies |
| ui-ux-specialist | Step-Back | Design principles before specific UI decisions |
| security-auditor | Self-Consistency + ReAct | Multi-angle threat analysis, verify with tools |
| api-architect | Step-Back + ToT | Principles first, then explore design options |
| performance-engineer | ReAct + CoT | Profile with real data, reason about bottlenecks |
| cloud-infrastructure | ToT + ReAct | Evaluate cloud options, verify with IaC plan |
| debugger | ReAct + CoT | Observe-hypothesize-test cycle, systematic elimination |
| git-workflow-manager | Few-Shot | Consistent commit formats, PR templates |
| database-architect | Step-Back + CoT | Principles first, then reason through schema decisions |
| technical-writer | Few-Shot | Consistent documentation formats and patterns |
| ui-ux-pro-max | Step-Back + Few-Shot | Industry principles first, then pattern-matched design decisions |
| pentester-auditor | ReAct + Self-Consistency | Observe-test-verify cycle, multi-angle vulnerability analysis |
| blue-team-engineer | ReAct + CoT | Check state before hardening, reason through defense layers |
| red-team-researcher | Step-Back + ToT | Strategic principles first, then explore attack scenarios |

---

## Related Documents

- [Prompting Techniques](../core/prompting-techniques.md) - Improve AI output quality per agent
- [Workflow Decision Tree](workflow-decision-tree.md) - Choose the right workflow
- [Template Selector](template-selector.md) - Choose the right template
- [Command Reference](command-reference.md) - Verification commands by category
- [INDEX.md](../INDEX.md) - Master navigation

*Last updated: 2026-03-08 | [Back to Index](../INDEX.md)*
