#!/bin/bash
export TF_VAR_ssh_pub_key=$(cat id_rsa.pub)

terraform plan
terraform apply -auto-approve
