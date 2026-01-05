# Onboarding Bootcamp Hackathon

A 2‑day, immersive technical bootcamp where new Solution Engineers learn by building real FSI‑grade solutions end‑to‑end. Each participant team chooses one of three industry tracks:

## 1. Capital Markets
- Trade ingestion → medallion pipeline
- Surveillance signals (pattern detection / summarization)
- Agent that triages alerts + drafts compliance summaries

## 2. Insurance
- Claims document intelligence → extracted entities
- Fraud signals + risk scoring
- Agent that guides adjuster workflow + generates customer correspondence

## 3. Banking
- Customer financial profile ingestion
- Suitability, portfolio analysis, product recommendations
- Agent that generates advisor scripts + outreach emails

Each track uses the same backbone architecture to reinforce core SE skills.


# Two‑Day Agenda 

## Day 1 — Foundations + Environment + Industry Deep Dive

### 8:30 – 9:00 | Welcome + Orientation
- Bootcamp purpose
- Track selection (Infra, App Innov, Data & AI + CM/Insurance/Banking)
- Roles: speaker, coaches, scorekeeper 

### 9:00 – 9:45 | Keynote: "FSI AI + Secure Cloud Foundations"
- Capital Markets, Insurance, Banking problem frames
- AI + Fabric + Foundry patterns

### TRACK BREAKOUTS START

#### Infra Track: Secure Infrastructure SE Bootcamp

**9:45 – 12:00**
- Deploy secure Landing Zone
- Networking, VNET integration, private endpoints
- Key Vault + Managed Identity
- Logging, Defender, APIM rate limits 

**1:00 – 4:30**
- Build secure runtime platform for FastAPI agent + Fabric pipelines
- Deploy APIM façade + global policies

#### App Innovation Track: Foundry + Cloud‑Native

**9:45 – 12:00**
- Microsoft Foundry project structure
- Container Apps + APIM + GitHub Actions CI/CD
- Zero‑trust patterns, Dapr

**1:00 – 4:30**
- Deploy FastAPI agent service using Foundry pattern
- OpenTelemetry instrumentation
- API-first contract design (5‑min pitch format)

#### Data & AI Track: Fabric + Agents

**9:45 – 12:00**
- Fabric medallion with OneLake shortcuts
- Bronze ingest → Silver clean → Gold industry marts
- Purview scans + classification + lineage 

**1:00 – 4:30**
- Build FastAPI tools + Copilot Agents
- Domain reasoners + retrieval from gold layer

#### 4:30 – 5:00 | Day 1 Wrap
- Progress review 
- Prep for Day 2

---

## Day 2 — Build, Harden, Pitch

### 8:30 – 9:00 | Stand‑Up
- Cross‑track unblockers
- Coach rotations 

### All Tracks (Unified Build)

**9:00 – 12:00**
- **Infra:** lock down security, alerts, identity + rate limits
- **App Innov:** finalize deployment + API proxy
- **Data & AI:** finalize agents + validate governance
- **Industry:** apply to CM/Insurance/Banking datasets


### 1:00 – 2:30 | Finalization + Storytelling
- Exec narrative  
- ROI articulation

### 2:30 – 4:00 | Demos + Pitches
- 5‑min pitch + 5‑min Q&A  
- Judges evaluate using rubric below

### 4:00 – 4:30 | Awards + Conversion Plan
- How to convert the hack into a customer offerClaude is AI and can make mistakes. Please double-check responses.

**Data policy:** prohibit real customer/production data; use scrubbed, open, or synthetic datasets and provide licensing guidance.

## Deliverables per team

### A. Architecture & Build (40%)
- Fabric medallion lakehouse with OneLake shortcuts; pipelines/notebooks operationalized.
- FastAPI service (Azure App Service or AKS) with auth, logging, and content filters.
- Copilot/Agent artifact (Studio or orchestration) wired to API + governance controls.

### B. Governance & Security (20%)
- Purview scan/classification + lineage; policy docs; data usage compliance.

### C. Business Value Story (25%)
- KPI baseline → projected impact, cost model, rollout plan; exec pitch (5–10 min).

### D. Reusability Assets (15%)
- README, IaC scripts, templates, and a "Book of Agents" entry to share org‑wide.

## Judging crew & roles

Minimum 1 lead speaker, 2–3 content speakers, 4–5 floating SMEs/coaches; timekeeper and scorekeeper for logistics