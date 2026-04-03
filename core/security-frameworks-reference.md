# Security Frameworks & Tools Reference

> **Executive Summary:** Curated index of cybersecurity frameworks, AI-powered security tools, standards, and research repositories used by the pentester-auditor, blue-team-engineer, and red-team-researcher agents. This is a reference document -- use it to find the right tool, framework, or standard for your security task.

| Metadata | Value |
|----------|-------|
| Type     | Core |
| Version  | 1.0.0 |
| Updated  | 2026-04-03 |
| Related  | [base-programming.md](base-programming.md), [../agents/pentester-auditor.md](../agents/pentester-auditor.md), [../agents/blue-team-engineer.md](../agents/blue-team-engineer.md), [../agents/red-team-researcher.md](../agents/red-team-researcher.md) |

---

## Quick Reference Card

### Framework Selection Guide

| Need | Framework | Agent |
|------|-----------|-------|
| Classify a vulnerability | CVSS 4.0 + CWE + OWASP Top 10 | pentester-auditor |
| Map attacker behavior | MITRE ATT&CK Enterprise | red-team-researcher |
| Harden a server | CIS Benchmarks | blue-team-engineer |
| Build security program | NIST CSF 2.0 or ISO 27001 | blue-team-engineer |
| Test a web application | OWASP Testing Guide + ASVS | pentester-auditor |
| Structure a pentest | PTES | pentester-auditor |
| Model threats to AI systems | MITRE ATLAS | red-team-researcher |

---

## Full Content

### Standards and Frameworks

#### Compliance & Governance

| # | Framework | Purpose | URL |
|---|-----------|---------|-----|
| 1 | NIST Cybersecurity Framework 2.0 | Enterprise security program structure | https://www.nist.gov/cyberframework |
| 2 | ISO 27001:2022 | Information security management system | https://www.iso.org/standard/27001 |
| 3 | CIS Controls v8 | Prioritized security actions | https://www.cisecurity.org/controls |
| 4 | CIS Benchmarks | System-specific hardening guides | https://www.cisecurity.org/cis-benchmarks |

#### Offensive Security

| # | Framework | Purpose | URL |
|---|-----------|---------|-----|
| 5 | PTES (Penetration Testing Execution Standard) | Pentest methodology | http://www.pentest-standard.org/ |
| 6 | OWASP Testing Guide v4.2 | Web application testing methodology | https://owasp.org/www-project-web-security-testing-guide/ |
| 7 | OWASP ASVS 4.0 | Application security verification | https://owasp.org/www-project-application-security-verification-standard/ |
| 8 | OWASP Top 10 (2021) | Top web application risks | https://owasp.org/www-project-top-10/ |
| 9 | OWASP Top 10 for LLM Applications (2025) | Top risks for LLM-based apps | https://owasp.org/www-project-top-10-for-large-language-model-applications/ |
| 10 | OWASP Agentic Top 10 (2026) | Top risks for agentic AI systems | https://owasp.org/www-project-top-10-for-large-language-model-applications/ |

#### Threat Intelligence

| # | Framework | Purpose | URL |
|---|-----------|---------|-----|
| 11 | MITRE ATT&CK Enterprise v15 | Adversary TTP catalog | https://attack.mitre.org/ |
| 12 | MITRE ATLAS | Adversarial threats to AI/ML systems | https://atlas.mitre.org/ |
| 13 | Cyber Kill Chain (Lockheed Martin) | Linear attack progression model | https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html |

#### Vulnerability Classification

| # | Standard | Purpose | URL |
|---|----------|---------|-----|
| 14 | CVSS 4.0 | Vulnerability severity scoring | https://www.first.org/cvss/v4.0/specification-document |
| 15 | CWE (Common Weakness Enumeration) | Software weakness catalog | https://cwe.mitre.org/ |
| 16 | CVE (Common Vulnerabilities and Exposures) | Known vulnerability database | https://www.cve.org/ |

---

### Multi-Agent Pentesting Frameworks (AI-Powered)

| # | Tool | Description | Repository |
|---|------|-------------|------------|
| 1 | CAI (Cybersecurity AI) | Open-source framework by Alias Robotics for autonomous security agents (Red Team, Bug Bounty, Blue Team). 300+ models, modular architecture. | https://github.com/aliasrobotics/cai |
| 2 | PentAGI | Autonomous multi-agent system with 20+ professional tools, Neo4j knowledge graph, long-term memory. | https://github.com/vxcontrol/pentagi |
| 3 | PentestAgent | Framework with /agent, /crew (multi-agent), /interact modes. Bidirectional MCP support, attack playbooks. | https://github.com/GH05TCREW/pentestagent |
| 4 | Redamon | Red team framework with Neo4j (17 node types), dual-agent triage pipeline, 11-section HTML reports, human-in-the-loop. | https://github.com/samugit83/redamon |
| 5 | HexStrike AI | MCP server with 150+ cybersecurity tools for AI agents (Claude, GPT, Copilot). 12+ autonomous agents. | https://github.com/0x4m4/hexstrike-ai |

### Code Auditing with LLM (Taskflows)

| # | Tool | Description | Repository |
|---|------|-------------|------------|
| 6 | GitHub Security Lab Taskflow Agent | Multi-agent MCP framework with YAML grammar for audit prompt chaining. 3-stage pipeline: threat modeling, issue suggestion, verification. 80+ vulns found in 40+ OSS repos. | https://github.com/GitHubSecurityLab/seclab-taskflow-agent |
| 7 | GitHub Security Lab Taskflows | Taskflow definitions for the above agent. | https://github.com/GitHubSecurityLab/seclab-taskflows |
| 8 | Agent Audit | Static scanner for LLM agents. 49 rules mapped to OWASP Agentic Top 10 (2026). Supports LangChain, CrewAI, AutoGen. | https://github.com/HeadyZhang/agent-audit |

### Red Teaming & Security Testing of AI Systems

| # | Tool | Description | Repository |
|---|------|-------------|------------|
| 9 | DeepTeam | Red teaming framework with 20+ adversarial attack methods, 40+ vulnerability classes, 7 production guardrails. | https://github.com/confident-ai/deepteam |
| 10 | Promptfoo | CLI for LLM app evaluation and red-teaming. Declarative YAML configs, CI/CD integration. | https://github.com/promptfoo/promptfoo |
| 11 | Agentic Radar | CLI scanner for agentic workflows. Workflow visualization, MCP server detection, vulnerability mapping. | https://github.com/splx-ai/agentic-radar |
| 12 | Agentic Security | Vulnerability scanner for LLM agent workflows. Fuzzing, jailbreaks, multimodal attacks. | https://github.com/msoedov/agentic_security |
| 13 | NVIDIA Garak | LLM vulnerability scanner by NVIDIA. | https://github.com/NVIDIA/garak |

### Offensive Security Tools (AI-Powered)

| # | Tool | Description | Reference |
|---|------|-------------|-----------|
| 14 | Shannon | Autonomous pentester by Keygraph for web apps/APIs. White-box testing. 96.15% success (100/104 exploits) on XBOW benchmark. | https://github.com/ottosulin/awesome-ai-security |
| 15 | Strix | Autonomous AI agents that execute code dynamically, find vulnerabilities, validate with PoC. | https://github.com/ottosulin/awesome-ai-security |
| 16 | HackingBuddyGPT | Ethical hacking assistant with LLMs in 50 lines of code or less. | https://github.com/ottosulin/awesome-ai-security |

### Curated Resource Collections (Master Indexes)

| # | Collection | Description | Repository |
|---|-----------|-------------|------------|
| 17 | Awesome Cybersecurity Agentic AI | Curated collection of frameworks, papers, datasets, and tools for agentic AI in cybersecurity. | https://github.com/raphabot/awesome-cybersecurity-agentic-ai |
| 18 | Awesome AI Security | Exhaustive collection of AI security resources: offensive/defensive tools, benchmarks, papers, podcasts, standards. | https://github.com/ottosulin/awesome-ai-security |
| 19 | AI Red Teaming Guide | Comprehensive guide for adversarial testing of AI systems. Covers OWASP, MITRE ATLAS, CSA MAESTRO. | https://github.com/requie/AI-Red-Teaming-Guide |
| 20 | Awesome LLMs for Vulnerability Detection | Academic paper collection on vulnerability detection with LLMs. | https://github.com/huhusmang/Awesome-LLMs-for-Vulnerability-Detection |

### Research Papers

| # | Paper | Topic | URL |
|---|-------|-------|-----|
| 21 | CAI Paper | Autonomous cybersecurity AI agents | https://arxiv.org/pdf/2504.06017 |
| 22 | Agent Audit Paper | Static analysis of LLM agents for security | https://arxiv.org/html/2603.22853 |
| 23 | CAI Documentation | Full documentation for CAI framework | https://aliasrobotics.github.io/cai/ |
| 24 | GitHub Security Lab Blog | How to scan for vulns with AI-powered framework | https://github.blog/security/how-to-scan-for-vulnerabilities-with-github-security-labs-open-source-ai-powered-framework/ |

---

## Anti-Patterns

| Wrong | Right | Why |
|-------|-------|-----|
| Using a single tool for all security assessments | Select tools based on target type and assessment scope | No single tool covers all vulnerability classes |
| Relying only on automated scanners | Combine automated scanning with manual verification | Scanners miss logic flaws and context-dependent vulnerabilities |
| Using outdated framework versions | Always reference the latest version of each standard | Security standards evolve to address new threat classes |
| Treating AI security tools as fully autonomous | Human review of all findings before action | AI tools produce false positives and may miss context |

---

## Related Documents

- [base-programming.md](base-programming.md) - Core development principles (security by default)
- [../agents/pentester-auditor.md](../agents/pentester-auditor.md) - Offensive security testing agent
- [../agents/blue-team-engineer.md](../agents/blue-team-engineer.md) - Defensive security agent
- [../agents/red-team-researcher.md](../agents/red-team-researcher.md) - Strategic security research agent
- [../agents/security-auditor.md](../agents/security-auditor.md) - Code-level security review agent
- [../workflows/security-audit.md](../workflows/security-audit.md) - Security Audit Mode workflow

*Last updated: 2026-04-03 | [Back to Index](../INDEX.md)*
