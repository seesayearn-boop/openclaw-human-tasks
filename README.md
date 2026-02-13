# 🌍 Loopuman — Human Intelligence Skill for OpenClaw

**When your AI agent can't do it alone, route it to a real human.**

Loopuman is an [OpenClaw](https://openclaw.ai) skill that gives your 🦞 access to verified human workers worldwide. Tasks are completed via Telegram and WhatsApp, with 8-second cryptocurrency payments on Celo.

## What It Does

```
You → "Hey Claw, get a human to verify this address"
       → Loopuman routes to verified worker pool
       → Worker completes task via Telegram
       → 8-sec cUSD payment on Celo
       → Result returned to your Claw
```

**Use cases:** verification, translation, content moderation, image labeling, surveys, data collection, QA on AI outputs — anything that needs real human judgment.

## Install

```bash
# Give your Claw this repo URL:
install the loopuman skill from https://github.com/loopuman/openclaw-human-tasks
```

## Setup

1. Get your API key (no auth needed):
```bash
curl -X POST https://api.loopuman.com/api/v1/register \
  -H "Content-Type: application/json" \
  -d '{"email": "you@example.com", "company_name": "Your Name"}'
```
2. Save the `api_key` from the response (starts with `lpm_`)
3. Configure:

```bash
mkdir -p ~/.openclaw/skills/loopuman
cat > ~/.openclaw/skills/loopuman/config.json << 'EOF'
{
  "apiKey": "YOUR_API_KEY",
  "apiUrl": "https://api.loopuman.com"
}
EOF
```

New accounts get **100 VAE free credits** (100 VAE = $1 USD).

## Usage

Just talk to your Claw naturally:

> "Get a human to verify if 456 Kenyatta Ave in Nairobi is a real business"

> "Use Loopuman to translate this paragraph to Swahili — make it sound natural"

> "Have someone rate these product images on quality, 1-10"

> "Ask a real person: which of these two logos looks more professional?"

## Pricing

100 VAE = $1.00 USD. Loopuman enforces a $6/hr minimum to ensure fair worker pay.

| Category | Min Budget | Typical Time |
|----------|-----------|-------------|
| `survey` / `labeling` / `micro` | 25 VAE ($0.25) | 1-5 min |
| `research` / `content_creation` | 75 VAE ($0.75) | 5-20 min |
| `writing` / `translation` | 100 VAE ($1.00) | 5-30 min |

## API

Auth: `x-api-key` header. Endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/tasks` | Create a task |
| GET | `/api/v1/tasks/:id` | Status + results |
| GET | `/api/v1/tasks` | List all tasks |
| DELETE | `/api/v1/tasks/:id` | Cancel (refund) |

See [references/api-reference.md](loopuman/references/api-reference.md) for full docs.

## Also Available Via

- **MCP**: `https://api.loopuman.com/.well-known/mcp.json`
- **A2A**: `https://api.loopuman.com/.well-known/agent-card.json`
- **ERC-8004**: Agent #17 on Celo — [8004scan](https://www.8004scan.io/agents/celo/17)

## Links

- 🌐 [loopuman.com](https://loopuman.com)
- 🤖 [@LoopumanBot](https://t.me/LoopumanBot)
- 📊 [8004scan Profile](https://www.8004scan.io/agents/celo/17)

## License

MIT
