# Security Audit Workflow

> **Executive Summary:** A structured, five-phase workflow for conducting comprehensive security evaluations. Every phase has responsible agents, mandatory outputs, and verification gates. This workflow coordinates the pentester-auditor, blue-team-engineer, red-team-researcher, and security-auditor agents into a systematic assessment pipeline. Use it for pre-release security gates, infrastructure audits, compliance evaluations, and periodic security reviews.

| Metadata | Value |
|----------|-------|
| Type     | Workflow |
| Version  | 1.0.0 |
| Updated  | 2026-04-03 |
| Related  | [verification-protocol.md](verification-protocol.md), [incident-response.md](incident-response.md), [evidence-report.md](../templates/evidence-report.md) |

---

## Quick Reference Card

### Five-Phase Timeline

| Phase | Responsible Agent | Time Budget | Output |
|-------|------------------|-------------|--------|
| 1 - RECONNAISSANCE | pentester-auditor | 60 min max | Attack surface map + technology fingerprint |
| 2 - ANALYSIS | pentester-auditor + security-auditor | 90 min max | Vulnerability findings + CVSS classification |
| 3 - EXPLOITABILITY | red-team-researcher | 60 min max | Kill chain analysis + risk scenarios |
| 4 - REMEDIATION | blue-team-engineer | 60 min max | Hardening plan + policy recommendations |
| 5 - REPORT | all security agents | 30 min max | Executive summary + technical findings + evidence |

Total maximum: 5 hours from scope definition to final report.

### Scope Authorization (Required)

```
SECURITY AUDIT SCOPE DEFINITION
================================
Target:         [Systems, networks, applications in scope]
Excluded:       [Systems explicitly out of scope]
Authorization:  [Name/role of authorizing person]
Date:           [Start date - End date]
Type:           [External / Internal / Web App / Infrastructure / Full]
Constraints:    [Business hours only? No DoS? Rate limits?]
```

### Phase Decision Tree

```
Scope authorized?
  NO  --> STOP. Do not proceed without authorization.
  YES --> Phase 1: RECONNAISSANCE
            |
            v
          Services and attack surface identified?
            NO  --> Expand reconnaissance scope (with approval)
            YES --> Phase 2: ANALYSIS
                      |
                      v
                    Vulnerabilities found?
                      NO  --> Document clean assessment, proceed to Phase 5
                      YES --> Phase 3: EXPLOITABILITY
                                |
                                v
                              Phase 4: REMEDIATION
                                |
                                v
                              Phase 5: REPORT
```

---

## Full Content

### Phase 1: RECONNAISSANCE

**Responsible:** pentester-auditor
**Time budget:** 60 minutes maximum
**Mandatory output:** Attack surface map

**Passive reconnaissance (first):**
- DNS enumeration: subdomains, MX, TXT (SPF/DKIM/DMARC), NS records
- Certificate transparency logs (crt.sh) for subdomain discovery
- WHOIS information and registrar details
- Search engine reconnaissance for exposed files/directories
- Public repository scanning for leaked credentials or internal paths
- Technology stack identification from public-facing responses

**Active reconnaissance (second):**
- Port scanning with service version detection
- OS fingerprinting
- Web technology fingerprinting (response headers, known paths)
- SSL/TLS configuration analysis
- API endpoint enumeration
- Virtual host discovery

**Phase 1 gate:** Attack surface map produced with:
- [ ] All in-scope hosts and services documented
- [ ] Technology stack per service identified
- [ ] Open ports and protocols cataloged
- [ ] SSL/TLS configuration assessed
- [ ] Initial risk observations noted

---

### Phase 2: ANALYSIS

**Responsible:** pentester-auditor + security-auditor (parallel)
**Time budget:** 90 minutes maximum
**Mandatory output:** Classified vulnerability findings

**pentester-auditor tasks:**
- Automated vulnerability scanning (Nuclei, Nmap scripts)
- Manual verification of automated findings
- Web application testing (OWASP Testing Guide v4.2)
- Authentication and session management analysis
- Input validation testing (injection vectors)
- Business logic flaw assessment

**security-auditor tasks (parallel):**
- Dependency audit (pip-audit, npm audit, Trivy)
- Secrets scanning (trufflehog, gitleaks)
- Configuration review against CIS Benchmarks
- HTTP security headers analysis
- CORS and CSP policy review
- Code-level pattern analysis (SAST)

**Phase 2 gate:** All findings classified with:
- [ ] Severity assigned (CVSS 4.0 score)
- [ ] CWE classification for each finding
- [ ] OWASP Top 10 mapping where applicable
- [ ] Evidence captured (request/response, screenshots, output)
- [ ] Each finding labeled: CONFIRMED / PROBABLE / THEORETICAL

---

### Phase 3: EXPLOITABILITY

**Responsible:** red-team-researcher
**Time budget:** 60 minutes maximum
**Mandatory output:** Risk scenarios with ATT&CK mapping

For each confirmed vulnerability from Phase 2:
- Model the complete attack chain (initial access to objective)
- Map TTPs to MITRE ATT&CK with technique IDs
- Assess real-world exploitability (weaponized exploit? skill required?)
- Calculate probability of exploitation (based on exposure + complexity)
- Estimate business impact if exploited
- Identify potential lateral movement from each finding
- Determine if findings chain together for compound impact

**Phase 3 gate:** Risk assessment produced with:
- [ ] Top 5 attack scenarios ranked by risk (probability x impact)
- [ ] ATT&CK mapping for each scenario
- [ ] Business impact quantified or described
- [ ] Compound/chained vulnerability scenarios identified
- [ ] Adversary profile matched to realistic threat actors

---

### Phase 4: REMEDIATION

**Responsible:** blue-team-engineer
**Time budget:** 60 minutes maximum
**Mandatory output:** Prioritized remediation plan

For each finding, produce a remediation action:

**Quick wins (0-48 hours):**
- Disable exposed services
- Patch critical CVEs
- Remove default credentials
- Enable missing security headers
- Fix open directory listings
- Revoke leaked credentials

**Short term (1-4 weeks):**
- Implement missing access controls
- Configure firewall rules
- Set up monitoring and alerting
- Enable MFA on all admin interfaces
- Deploy automated dependency scanning in CI/CD
- Configure log aggregation

**Medium term (1-3 months):**
- Network segmentation
- Zero-trust architecture adoption
- EDR/HIDS deployment
- Security awareness training
- Formal patch management process
- Regular vulnerability scan schedule

**Long term (architectural):**
- Re-architecture of insecure components
- Full compliance program (ISO 27001, NIST CSF)
- Disaster recovery testing program
- Red team exercise program (annual)

**Phase 4 gate:** Remediation plan produced with:
- [ ] Every finding has a remediation action
- [ ] Actions prioritized by risk reduction per effort
- [ ] Responsible team/person assigned per action
- [ ] Timeline for each action
- [ ] Verification method defined (how to confirm fix works)

---

### Phase 5: REPORT

**Responsible:** All security agents collaborate
**Time budget:** 30 minutes maximum
**Mandatory output:** Complete security audit report

**Report structure:**

```
SECURITY AUDIT REPORT
=====================

1. EXECUTIVE SUMMARY (non-technical)
   - Scope and methodology
   - Overall risk level: CRITICAL / HIGH / MEDIUM / LOW
   - Key findings count by severity
   - Top 3 business risks
   - Recommended immediate actions

2. SCOPE AND METHODOLOGY
   - Targets assessed
   - Testing methodology (PTES, OWASP)
   - Tools used
   - Limitations and constraints
   - Authorization reference

3. ATTACK SURFACE MAP
   - Network topology
   - Services and technologies
   - Entry points identified

4. FINDINGS BY SEVERITY
   [CRITICAL findings first, then HIGH, MEDIUM, LOW, INFORMATIONAL]
   Each finding follows the standard classification format.

5. RISK ANALYSIS
   - Top attack scenarios
   - MITRE ATT&CK mapping
   - Compound vulnerability chains
   - Business impact assessment

6. REMEDIATION PLAN
   - Quick wins (0-48h)
   - Short term (1-4 weeks)
   - Medium term (1-3 months)
   - Long term (architectural)

7. COMPLIANCE GAPS
   - Framework reference (CIS, NIST, ISO)
   - Current vs. required state
   - Gap closure roadmap

8. MONITORING RECOMMENDATIONS
   - Detection rules to implement
   - KPIs to track
   - Re-assessment schedule

APPENDICES
   A. Detailed evidence for each finding
   B. Tool output and scan reports
   C. Remediation verification procedures
```

**Phase 5 gate:** Report delivered with:
- [ ] Executive summary is understandable by non-technical stakeholders
- [ ] Every finding has evidence attached
- [ ] Remediation plan has timelines and owners
- [ ] CVSS + CWE classification on all findings
- [ ] Report is self-contained (no external references required for understanding)

---

## Rules

1. **Every evaluation requires explicitly authorized scope.** No exceptions.
2. **Without reproducible evidence, mark as [THEORETICAL].** Never present unverified findings as confirmed.
3. **Always classify with CVSS + CWE + severity.** Unclassified findings are incomplete.
4. **Passive before active.** Exhaust passive reconnaissance before any active interaction.
5. **Business impact over technical severity.** A medium-CVSS finding on a crown-jewel system may be higher priority than a high-CVSS finding on a test server.
6. **Remediation must be actionable.** "Fix the vulnerability" is not a remediation. Specify what to do, how, and how to verify.

---

## Agent Collaboration Presets

| Audit Type | Agent Sequence | Notes |
|------------|---------------|-------|
| Quick web app assessment | security-auditor + pentester-auditor (parallel) | Skip Phases 3-4 for speed |
| Full infrastructure audit | pentester-auditor -> security-auditor -> red-team-researcher -> blue-team-engineer | All 5 phases, sequential |
| Compliance evaluation | blue-team-engineer + security-auditor (parallel) | Focus on Phases 2 + 4 |
| Threat assessment (no testing) | red-team-researcher | Phase 3 only, theoretical |
| Incident-driven audit | blue-team-engineer -> pentester-auditor -> red-team-researcher | Start from incident, find root cause |

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Starting active scanning without scope authorization | Always have written scope before any testing | Unauthorized scanning is illegal and unethical |
| Skipping passive recon to save time | Complete passive recon first, then active | Passive recon often reveals more with less risk |
| Reporting raw scanner output as findings | Verify, classify, and contextualize every finding | Raw output lacks actionability and contains false positives |
| Producing a report with no remediation plan | Every finding must have a specific, actionable fix | Identifying problems without solutions is incomplete work |
| Testing in production during peak hours | Schedule during maintenance windows or use rate-limited profiles | Active testing can degrade service availability |

---

## Related Documents

- [verification-protocol.md](verification-protocol.md) - Evidence collection standards
- [incident-response.md](incident-response.md) - When audit findings indicate active compromise
- [../agents/pentester-auditor.md](../agents/pentester-auditor.md) - Offensive testing agent
- [../agents/blue-team-engineer.md](../agents/blue-team-engineer.md) - Defensive security agent
- [../agents/red-team-researcher.md](../agents/red-team-researcher.md) - Strategic security agent
- [../agents/security-auditor.md](../agents/security-auditor.md) - Code-level security agent
- [../core/security-frameworks-reference.md](../core/security-frameworks-reference.md) - Framework and tool index
- [../templates/evidence-report.md](../templates/evidence-report.md) - Report format reference

*Last updated: 2026-04-03 | [Back to Index](../INDEX.md)*
