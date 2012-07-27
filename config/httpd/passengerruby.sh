#!/bin/bash
export PAPYRI_DATABASE_NAME="//host/service"
export PAPYRI_DATABASE_USER="username"
export PAPYRI_DATABASE_PASS="password"
export PAPYRI_LDAP_HOST="oneid_host"
export PAPYRI_LDAP_PORT="1234"
export PAPYRI_LDAP_USER="username"
export PAPYRI_LDAP_PASSWORD="password"
/usr/local/bin/ruby $*
