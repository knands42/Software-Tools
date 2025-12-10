#!/usr/bin/env bash
set -e

##############################################
# CONFIGURATION
##############################################

# Number of days certificates will be valid
VALID_DAYS=3650

# Output directory
OUTDIR="vpn-certs"

# RSA key size AWS supports: 1024 or 2048 (2048 recommended)
RSA_BITS=2048


##############################################
# PREP
##############################################

rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

echo "📁 Certificates will be created in: $(pwd)"
echo "🔐 Using RSA: ${RSA_BITS}-bit keys"
echo "📅 Validity: $VALID_DAYS days"
echo


#########################################
# Create OpenSSL extension files
#########################################

# Server extensions
cat > server-ext.cnf <<EOF
keyUsage = ANY
extendedKeyUsage = serverAuth
subjectAltName = DNS:myserver.com
EOF

# Client extensions
cat > client-ext.cnf <<EOF
keyUsage = ANY
extendedKeyUsage = clientAuth
EOF

# CA extensions
cat > ca-ext.cnf <<EOF
basicConstraints = critical, CA:true
keyUsage = ANY
EOF


##############################################
# 1️⃣ CREATE RSA ROOT CA
##############################################

echo "==> Creating CA private key..."
openssl genrsa -out ca.key $RSA_BITS

echo "==> Creating self-signed CA certificate..."
openssl req -x509 -new -nodes \
  -key ca.key \
  -sha256 \
  -days "$VALID_DAYS" \
  -out ca.crt \
  -subj "/CN=my-rsa-ca" \
  -extensions v3_ca \
  -config <(cat /etc/ssl/openssl.cnf ; echo "[v3_ca]"; cat ca-ext.cnf)


echo "✔️ CA created: ca.key + ca.crt"
echo


##############################################
# 2️⃣ CREATE RSA SERVER CERTIFICATE
##############################################

echo "==> Creating server private key..."
openssl genrsa -out server.key $RSA_BITS

echo "==> Creating server CSR..."
openssl req -new \
  -key server.key \
  -out server.csr \
  -subj "/CN=myserver.com" \
  -addext "subjectAltName=DNS:myserver.com,DNS:www.myserver.com,DNS:myserver.com,IP:127.0.0.1"

echo "==> Signing server certificate with CA..."
openssl x509 -req \
  -in server.csr \
  -CA ca.crt \
  -CAkey ca.key \
  -CAcreateserial \
  -out server.crt \
  -days "$VALID_DAYS" \
  -sha256 \
  -extfile server-ext.cnf

echo "✔️ Server certificate signed: server.crt"
echo


##############################################
# 3️⃣ CREATE RSA CLIENT CERTIFICATE
##############################################

echo "==> Creating client private key..."
openssl genrsa -out client.key $RSA_BITS

echo "==> Creating client CSR..."
openssl req -new \
  -key client.key \
  -out client.csr \
  -subj "/CN=vpn-client"

echo "==> Signing client certificate with CA..."
openssl x509 -req \
  -in client.csr \
  -CA ca.crt \
  -CAkey ca.key \
  -CAcreateserial \
  -out client.crt \
  -days "$VALID_DAYS" \
  -sha256 \
  -extfile client-ext.cnf

echo "✔️ Client certificate signed: client.crt"
echo


##############################################
# 4️⃣ SUMMARY
##############################################

echo "================================================="
echo "🏁 DONE! Your RSA-based VPN certificates are ready."
echo
echo "Files generated:"
echo "  CA:"
echo "    ca.key  (PRIVATE — keep secret!)"
echo "    ca.crt"
echo
echo "  Server:"
echo "    server.key (private)"
echo "    server.csr"
echo "    server.crt"
echo
echo "  Client:"
echo "    client.key (private)"
echo "    client.csr"
echo "    client.crt"
echo
echo "➡️ Upload to AWS ACM for Client VPN:"
echo "    - server.key"
echo "    - server.crt"
echo "    - ca.crt (as certificate chain)"
echo
echo "➡️ Set root_certificate_chain_arn to ARN of uploaded ca.crt"
echo "================================================="
