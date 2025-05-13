#!/bin/bash

export GITLAB_TOKEN="read from environment"
export NGROK_AUTHTOKEN="read from environment"

kubefirst k3d create \
  --git-provider github \
  --gitlab-group docondee \
  --git-protocol https \
  --cluster-name docondee-cluster

