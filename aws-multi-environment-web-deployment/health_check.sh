#!/bin/bash

# Load API Endpoint from terraform outputs
API_ENDPOINT=$(jq -r '.api_endpoint.value' terraform_outputs.json)

echo "Checking API Endpoint: $API_ENDPOINT"

for env in staging prod
do
  RESPONSE=$(curl -s "$API_ENDPOINT/$env")

  if [[ "$env" == "staging" && "$RESPONSE" == *"Staging Environment"* ]]; then
    echo "[OK] staging is healthy: $API_ENDPOINT/$env"
  elif [[ "$env" == "prod" && "$RESPONSE" == *"Production Environment"* ]]; then
    echo "[OK] production is healthy: $API_ENDPOINT/$env"
  else
    echo "[FAIL] $env is unhealthy: $API_ENDPOINT/$env"
  fi
done
