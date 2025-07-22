#!/bin/bash

set -e

terraform output -json > terraform_outputs.json

# Load Terraform outputs
JUMPBOX_IP=$(jq -r '.jumpbox_ip.value' terraform_outputs.json)
STAGING_IP=$(jq -r '.staging_private_ip.value' terraform_outputs.json)
PROD_IP=$(jq -r '.production_private_ip.value' terraform_outputs.json)
API_ENDPOINT=$(jq -r '.api_endpoint.value' terraform_outputs.json)

echo "Jumpbox IP: $JUMPBOX_IP"
echo "Staging IP: $STAGING_IP"
echo "Production IP: $PROD_IP"
echo "API Endpoint: $API_ENDPOINT"

KEY_PATH=multi-env-key.pem

deploy_env() {
  ENV=$1
  TARGET_IP=$2

  if [[ "$TARGET_IP" == "$JUMPBOX_IP" ]]; then
    echo "Deploying to Jumpbox directly..."

    ssh -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -i $KEY_PATH ubuntu@$JUMPBOX_IP \
    "echo 'Jumpbox is reachable and SSH works'"

  else
    echo "Deploying $ENV via Jumpbox to $TARGET_IP..."

    ssh -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -i $KEY_PATH \
    -o ProxyCommand="ssh -W %h:%p -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $KEY_PATH ubuntu@$JUMPBOX_IP" \
    ubuntu@$TARGET_IP << EOF
sudo apt update -y
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2

# Configure Apache VirtualHost to accept any Host header
sudo bash -c 'cat > /etc/apache2/sites-available/000-default.conf <<EOT
<VirtualHost *:80>
    DocumentRoot /var/www/html
    ServerName localhost
    ServerAlias *

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOT'

# Create index.html with environment name
echo "<h1>$ENV Environment</h1>" | sudo tee /var/www/html/index.html

# Create .htaccess to rewrite /staging and /prod to /
cat <<EOT | sudo tee /var/www/html/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_URI} ^/(staging|prod)\$
RewriteRule ^(staging|prod)\$ / [L]
EOT

# Enable mod_rewrite
sudo a2enmod rewrite

# Restart Apache to apply changes
sudo systemctl restart apache2

exit 0
EOF

  fi
}

# Deploy to staging and production EC2s via Jumpbox
deploy_env staging $STAGING_IP
deploy_env production $PROD_IP

# Health Check
if [[ "$API_ENDPOINT" == "null" ]]; then
  echo "API Gateway endpoint not available. Skipping health checks."
else
  echo "Running Health Checks..."
  for ENV in staging prod
  do
    RESPONSE=$(curl -s $API_ENDPOINT/$ENV)
    if [[ $RESPONSE == *"$ENV"* ]]; then
      echo "[OK] $ENV is healthy: $API_ENDPOINT/$ENV"
    else
      echo "[FAIL] $ENV is unhealthy: $API_ENDPOINT/$ENV"
    fi
  done
fi
