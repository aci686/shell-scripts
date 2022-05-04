#!/usr/bin/env bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Uses OpenSSL libraries to manage CA certificates
# Right now only new certs issuing

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

# Fill the following variables with your data. It must match your own CA
CA_DIR=''
COUNTRY=''
PROVINCE=''
ORGANIZATION=''
EMAIL=''

usage() {                                  
    echo "[i] Usage: $0 <san>" 1>&2
    exit 0
}

if [ -z "$1" ]; then
    usage
fi

# Key generation
echo "[i] Creating private key..."
openssl genrsa -aes256 -out $CA_DIR/private/$1.key.pem 2048

# Conf file generation
echo "[i] Building configuration file..."
cat << EOF > $CA_DIR/$1.conf
[ ca ]
default_ca                      =  CA_default

[ CA_default ]
dir                             =  $CA_DIR
certs                           =  $CA_DIR/certs
crl_dir                         =  $CA_DIR/crl
new_certs_dir                   =  $CA_DIR/newcerts
database                        =  $CA_DIR/index.txt
serial                          =  $CA_DIR/serial
RANDFILE                        =  $CA_DIR/private/.rand

private_key                     =  $CA_DIR/private/ca.key.pem
certificate                     =  $CA_DIR/certs/ca.cert.pem
crlnumber                       =  $CA_DIR/crlnumber
crl                             =  $CA_DIR/crl/ca.crl.pem
crl_extensions                  =  crl_ext
default_crl_days                =  30

default_md                      =  sha256
name_opt                        =  ca_default
cert_opt                        =  ca_default
default_days                    =  375
preserve                        =  no
policy                          =  policy_strict

[ policy_strict ]
countryName                     =  match
stateOrProvinceName             =  match
organizationName                =  match
organizationalUnitName          =  optional
commonName                      =  optional
emailAddress                    =  optional

[ policy_loose ]
countryName                     =  optional
stateOrProvinceName             =  optional
localityName                    =  optional
organizationName                =  optional
organizationalUnitName          =  optional
commonName                      =  optional
emailAddress                    =  optional

[ req ]
default_bits                    =  2048
distinguished_name              =  req_distinguished_name
string_mask                     =  utf8only
default_md                      =  sha256
x509_extensions                 =  v3_ca
req_extensions                  =  v3_req

[ req_distinguished_name ]
countryName                     =  Country Name (2 letter code)
stateOrProvinceName             =  State or Province Name
localityName                    =  Locality Name
0.organizationName              =  Organization Name
organizationalUnitName          =  Organizational Unit Name
commonName                      =  Common Name
emailAddress                    =  Email Address
countryName_default             =  $COUNTRY 
stateOrProvinceName_default     =  $PROVINCE
localityName_default            =
0.organizationName_default      =  $ORGANIZATION
commonName_default              =  $1
organizationalUnitName_default  =  
emailAddress_default            =  $EMAIL

[ v3_ca ]
subjectKeyIdentifier            =  hash
authorityKeyIdentifier          =  keyid:always,issuer
basicConstraints                =  critical, CA:true
keyUsage                        =  critical, digitalSignature, cRLSign, keyCertSign
subjectAltName                  =  @alternate_names

[ v3_intermediate_ca ]
subjectKeyIdentifier            =  hash
authorityKeyIdentifier          =  keyid:always,issuer
basicConstraints                =  critical, CA:true, pathlen:0
keyUsage                        =  critical, digitalSignature, cRLSign, keyCertSign

[ v3_req ]
basicConstraints                =  CA:FALSE
subjectKeyIdentifier            =  hash
subjectAltName                  =  @alternate_names
keyUsage                        =  nonRepudiation, digitalSignature, keyEncipherment

[ alternate_names ]
DNS.1                           =  $1 

[ usr_cert ]
basicConstraints                =  CA:FALSE
nsCertType                      =  client, email
nsComment                       =  "OpenSSL Generated Client Certificate"
subjectKeyIdentifier            =  hash
authorityKeyIdentifier          =  keyid,issuer
keyUsage                        =  critical, nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage                =  clientAuth, emailProtection

[ server_cert ]
basicConstraints                =  CA:FALSE
nsCertType                      =  server
nsComment                       =  "OpenSSL Generated Server Certificate"
subjectKeyIdentifier            =  hash
authorityKeyIdentifier          =  keyid,issuer:always
keyUsage                        =  critical, digitalSignature, keyEncipherment
extendedKeyUsage                =  serverAuth

[ crl_ext ]
authorityKeyIdentifier          =  keyid:always

[ ocsp ]
basicConstraints                =  bjectKeyIdentifier            =  hash
authorityKeyIdentifier          =  keyid,issuer
keyUsage                        =  critical, digitalSignature
extendedKeyUsage                =  critical, OCSPSigning
EOF

# CSR generation
echo "[i] Creating Certificate Signing Request..."
openssl req -new -config $CA_DIR/$1.conf -key $CA_DIR/private/$1.key.pem -sha256 -out $CA_DIR/csr/$1.csr.pem

# CSR sign
echo "[i] Sign and issue certificate..."
openssl ca -config $CA_DIR/$1.conf -extensions server_cert -days 365 -notext -md sha256 -in $CA_DIR/csr/$1.csr.pem -out $CA_DIR/certs/$1.cert.pem -extensions v3_req

# Export cert + private + public key
echo "[i] Certificate package export..."
openssl req -in $CA_DIR/csr/$1.csr.pem -noout -pubkey > $HOME/$1.key
cp $CA_DIR/certs/$1.cert.pem $HOME
cp $CA_DIR/private/$1.key.pem $HOME

