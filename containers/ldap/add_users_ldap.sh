#!/bin/bash
ldapadd -x -D cn=admin,dc=libertempo -w admin -f /opt/run/content.ldif
