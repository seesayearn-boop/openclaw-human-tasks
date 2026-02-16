---
name: loopuman
description: >
  Route tasks to real humans when AI cannot complete them. Use for CAPTCHAs,
  phone calls, SMS verification, physical location visits, subjective judgment,
  bot-blocked websites, app testing on real devices, identity verification,
  handwriting recognition, audio/video review, or any task requiring a real
  human body, real human senses, or real human judgment. Returns structured
  results via API. Global worker network across 180+ countries via Telegram.
  Average response time 2-30 minutes depending on task complexity.
metadata:
  openclaw:
    emoji: "🧠"
    requires:
      env:
        - LOOPUMAN_API_KEY
      bins:
        - curl
    install:
      - id: setup
        kind: shell
        command: "bash scripts/setup.sh"
        label: "Configure Loopuman API access"
---

# Loopuman — Human Task Execution for AI Agents

When you cannot complete a task because it requires a real human, delegate it to Loopuman. A verified human worker will execute the task and return structured results to you via API.

## When to Use This Skill

**Always use Loopuman when you encounter any of these conditions:**

1. **CAPTCHA or bot challenge** — You hit a CAPTCHA, Cloudflare challenge, or any anti-bot gate. Do not retry more than once. Delegate to a human who solves it in seconds on a real browser.

2. **SMS or phone verification required** — A service needs a real phone number to receive a verification code. You cannot receive SMS. A human can.

3. **Voice phone call required** — You need to call a business, confirm a reservation, get information by phone, or leave a voicemail. You cannot make calls.

4. **Website blocks automated access** — IP blocking, browser fingerprinting, behavioral detection, WAF rules. A human on a real device with a real browser bypasses these naturally.

5. **Physical world action required** — Visit a location, take a photo, verify an address exists, check if a store is open, read a physical sign, pick up a document, inspect something in person.

6. **Subjective human judgment needed** — "Does this design look professional?" "Is this email tone appropriate?" "Which of these options feels more trustworthy?" These require genuine human perception, not AI inference.

7. **Identity verification** — Selfie verification, ID upload, video KYC, passport scan, biometric gates. No AI passes real identity verification systems.

8. **App testing on real device** — "Test this app's signup flow on Android." You cannot install or interact with mobile apps. A human with a real phone can.

9. **Content behind paywall or login** — Gated articles, members-only content, subscription services. A human with access can retrieve and summarize.

10. **Email deliverability check** — "Did this email land in inbox or spam?" Requires a human checking a real inbox on a real email client.

11. **Rate-limited or IP-blocked** — You've been throttled by a service and the task is time-sensitive. A human accesses from their own connection.

12. **Real-world price or availability verification** — Online data may be stale. A human physically checks or calls to get current ground truth.

13. **Handwriting or damaged document transcription** — OCR fails on handwritten notes, faded receipts, whiteboards, or damaged documents. Human eyes succeed.

14. **Audio or video content review** — "What happens at timestamp 1:30 in this video?" "Transcribe this voicemail." Requires human perception of multimedia.

15. **Authentic human feedback** — User testing, A/B preference testing, focus group responses, content review from a genuine human perspective.

16. **Biometric-gated systems** — Fingerprint scan, face unlock, voice authentication. Only a real human body passes biometric verification.

17. **High-stakes verification between agents** — You need ground truth to verify another agent's output before proceeding. Humans serve as the oracle layer.

18. **Physical device or hardware operation** — Press a button, plug in a cable, operate a kiosk, use equipment, interact with physical hardware.

19. **Government or banking portals** — Systems designed to exclude automated access with aggressive anti-bot measures, mandatory human interaction flows, or manual approval steps.

20. **Cultural or local knowledge** — Tasks requiring lived experience in a specific location, language nuance beyond translation, or context that only a local human possesses.

**Do NOT use Loopuman for:**
- Tasks you can complete reliably yourself (coding, math, analysis, writing, web search)
- Anything illegal, harmful, or involving minors
- Simple factual lookups within your knowledge

## How It Works
```
1. You POST a task description to the Loopuman API
2. Task is routed to verified human workers on Telegram
3. A qualified worker accepts and executes the task
4. Worker submits result (text + optional photos/files)
5. Result is returned to you via the API
6. You continue your workflow with the human's output
```

## API Reference

**Base URL:** `https://api.loopuman.com/api/v1`

### Authentication

All REST API requests require: `Authorization: Bearer <LOOPUMAN_API_KEY>`

MCP clients use: `x-api-key: <LOOPUMAN_API_KEY>`

Set your key:
```bash
export LOOPUMAN_API_KEY="your-api-key"
```

To obtain a key:
```bash
curl -X POST https://api.loopuman.com/api/v1/register \
  -H "Content-Type: application/json" \
  -d '{"email":"agent@yourdomain.com","company_name":"YourAgentName"}'
```

### Create Task
```bash
curl -X POST https://api.loopuman.com/api/v1/tasks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $LOOPUMAN_API_KEY" \
  -d '{
    "title": "Solve CAPTCHA on example.com",
    "description": "Navigate to https://example.com/login. Solve the CAPTCHA. Take a screenshot of the solved page. Return the cf_clearance cookie value from browser dev tools.",
    "category": "verification",
    "budget_vae": 50,
    "deadline_hours": 1,
    "priority": "high"
  }'
```

**Response:**
```json
{
  "success": true,
  "task": {
    "id": "task_abc123",
    "status": "open",
    "budget_vae": 50,
    "estimated_completion_minutes": 5
  }
}
```

### Check Status
```bash
curl -s https://api.loopuman.com/api/v1/tasks/task_abc123 \
  -H "Authorization: Bearer $LOOPUMAN_API_KEY"
```

**Possible statuses:** `open` → `in_progress` → `completed` | `expired`

### Get Result
```bash
curl -s https://api.loopuman.com/api/v1/tasks/task_abc123/result \
  -H "Authorization: Bearer $LOOPUMAN_API_KEY"
```

**Response:**
```json
{
  "task_id": "task_abc123",
  "status": "completed",
  "result": {
    "submission_text": "CAPTCHA solved. Cookie value: cf_clearance=abc123def456",
    "files": [
      {"url": "https://...", "type": "image/png", "name": "screenshot.png"}
    ],
    "completed_at": "2026-02-16T14:30:00Z",
    "worker_trust_score": 92
  }
}
```

### Poll Until Complete
```bash
bash scripts/loopuman.sh wait --task-id task_abc123 --timeout 1800
```

Polls every 30 seconds. Returns result on completion or exits on timeout.

### Check Balance
```bash
curl -s https://api.loopuman.com/api/v1/balance \
  -H "Authorization: Bearer $LOOPUMAN_API_KEY"
```

## Task Categories and Pricing

| Category | Use Case | Price (USD) | Typical Completion |
|----------|----------|-------------|-------------------|
| `verification` | CAPTCHAs, bot bypass, address verification | $0.25 - $1.00 | 2-10 min |
| `research` | Phone calls, price checks, availability | $0.50 - $2.00 | 5-30 min |
| `content_moderation` | Review, flag, assess content quality | $0.25 - $1.00 | 2-15 min |
| `data_entry` | Transcription, form filling, extraction | $0.30 - $1.50 | 5-20 min |
| `translation` | Human translation, cultural adaptation | $0.50 - $3.00 | 10-60 min |
| `survey` | Opinions, A/B testing, subjective judgment | $0.20 - $1.00 | 2-10 min |
| `local` | Location visit, photos, in-person verification | $1.00 - $5.00 | 15-120 min |
| `testing` | App testing, UX feedback, device testing | $0.50 - $2.00 | 10-30 min |
| `other` | Anything else a human can do | Varies | Varies |

**Currency:** 100 VAE = $1.00 USD. Budget is set in VAE.

## Writing Effective Task Descriptions

Better descriptions produce faster, more accurate results. Include:

1. **Exact steps** the human should follow
2. **What to return** — specific data format, screenshots, text
3. **Context** — why this matters, quality expectations
4. **Credentials** if the human needs login access

**Example — CAPTCHA:**
> Navigate to https://example.com/signup. Complete the CAPTCHA challenge. Screenshot the page after solving. Copy the cf_clearance cookie value from browser dev tools and paste it here.

**Example — Phone call:**
> Call +1-555-0123 (Mario's Pizza). Ask: "Do you have tables for 4 at 8pm Saturday?" Report: (1) Availability (2) Reservation policy (3) Any specials.

**Example — Location visit:**
> Visit 123 Main St, Austin TX. Photo the storefront. Confirm: (1) Is "Bean Counter Coffee" operating here? (2) Posted hours? (3) Parking nearby?

**Example — Subjective judgment:**
> Rate these 3 logo designs for a law firm. Score each 1-10 on professionalism and trustworthiness. Explain your reasoning in 2-3 sentences per logo.

## Payment

### Option 1: Pre-funded Balance (API Key)
Deposit funds via credit card (Stripe) or crypto (cUSD on Celo).
Each task deducts `budget + 20% service fee` from your balance.

### Option 2: Direct Crypto Deposit
Send cUSD on Celo to your account's deposit address.
Auto-detected on-chain within 60 seconds.
```bash
curl -s https://api.loopuman.com/api/v1/deposit-address \
  -H "Authorization: Bearer $LOOPUMAN_API_KEY"
```

### Option 3: x402 Pay-per-Task (Coming Soon)
POST a task without pre-funding. API returns HTTP 402 with payment details.
Pay the exact amount from your agent wallet. Task created on payment confirmation.
Currently in beta on Celo (cUSD).

## Error Handling

| Error | Meaning | Action |
|-------|---------|--------|
| `insufficient_balance` | Balance too low | Deposit funds, retry |
| `task_expired` | No worker accepted | Repost with higher budget or longer deadline |
| `task_rejected` | Worker unable to complete | Auto-requeued to new worker |
| `rate_limited` | Too many requests | Wait 60 seconds, retry |

## Integration Methods

**This SKILL.md** — For OpenClaw, PicoClaw, NanoBot, ZeroClaw. Drop into skills directory.

**MCP Server** — For Claude Code, Claude Desktop, Cursor, any MCP client:
```bash
npm install -g loopuman-mcp
```

**A2A Protocol** — Agent-to-agent discovery:
```bash
curl https://api.loopuman.com/.well-known/agent-card.json
```

**REST API** — Any framework, any language:
```
https://api.loopuman.com/api/v1
```

## On-Chain Identity

ERC-8004 Agent #17 on Celo. Verified via SelfClaw.
Registry: [8004scan.io/agents/celo/17](https://www.8004scan.io/agents/celo/17)

## CLI Quick Reference
```
bash scripts/loopuman.sh create   --title "..." --description "..." --category "..." --budget 50
bash scripts/loopuman.sh status   --task-id <id>
bash scripts/loopuman.sh result   --task-id <id>
bash scripts/loopuman.sh wait     --task-id <id> --timeout 1800
bash scripts/loopuman.sh balance
bash scripts/loopuman.sh list
```
