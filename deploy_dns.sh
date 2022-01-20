#!/bin/bash

cd ansible-collections

ansible-playbook -i inventory deploy-caas-dns-core-2.yml && ansible-playbook -i inventory deploy-caas-dns-core-1.yml
