#!/usr/bin/env bash
# Prueba del webhook lead-capture.
# Ajusta WEBHOOK_URL según tu instancia de n8n y modo (test o producción).

WEBHOOK_URL="${WEBHOOK_URL:-http://localhost:5678/webhook/lead-capture}"

curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d @"$(dirname "$0")/sample-payload.json" \
  -w "\n[HTTP %{http_code}]\n"
