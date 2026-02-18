#!/bin/bash
# Loopuman API Key Setup
# Two modes: interactive (for humans) and auto (for agents)

set -e

# Auto-registration for agents (non-interactive)
if [ "$1" = "--auto" ] || [ -n "$LOOPUMAN_AUTO_REGISTER" ]; then
  EMAIL="${LOOPUMAN_EMAIL:-auto-$(date +%s)@agent.loopuman.com}"
  COMPANY="${LOOPUMAN_COMPANY:-AutoAgent}"
  
  RESPONSE=$(curl -s -X POST https://api.loopuman.com/api/v1/register \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$EMAIL\",\"company_name\":\"$COMPANY\",\"promo_code\":\"CLAW500\"}")
  
  API_KEY=$(echo "$RESPONSE" | grep -o '"api_key":"[^"]*"' | cut -d'"' -f4)
  
  if [ -z "$API_KEY" ]; then
    echo "Registration failed: $RESPONSE" >&2
    exit 1
  fi
  
  echo "export LOOPUMAN_API_KEY=$API_KEY"
  exit 0
fi

# Interactive registration (for humans)
echo "=== Loopuman Setup ==="
echo "Registering for a free API key (includes \$5 credit)..."
echo ""

read -p "Email: " EMAIL
read -p "Company/Agent name: " COMPANY

RESPONSE=$(curl -s -X POST https://api.loopuman.com/api/v1/register \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"company_name\":\"$COMPANY\",\"promo_code\":\"CLAW500\"}")

API_KEY=$(echo "$RESPONSE" | grep -o '"api_key":"[^"]*"' | cut -d'"' -f4)

if [ -z "$API_KEY" ]; then
  echo "Registration failed. Response:"
  echo "$RESPONSE"
  exit 1
fi

echo ""
echo "✅ Registration successful!"
echo ""
echo "Your API key: $API_KEY"
echo ""
echo "Add to your environment:"
echo "  export LOOPUMAN_API_KEY=$API_KEY"
echo ""
echo "Or add to .env file:"
echo "  echo 'LOOPUMAN_API_KEY=$API_KEY' >> .env"
echo ""
echo "You have \$5.00 free credit (500 VAE). Try it:"
echo "  bash scripts/loopuman.sh create --title 'Test task' --description 'Say hello!' --category 'other' --budget 50"
